FROM ruby:3.3.5-alpine

RUN apk --update-cache add --update --virtual build-dependencies alpine-sdk postgresql-dev ruby-dev

# Keep build-base and Git to be able install updated gems later
RUN apk --update-cache add --update build-base git tzdata postgresql-client \
  libffi-dev libxml2-dev libxslt-dev gcompat

ENV APP_HOME /app

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/

# Cache gems
ENV BUNDLE_PATH=/bundle \
  BUNDLE_BIN=/bundle/bin \
  GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

# Install gems
RUN gem update --system
RUN gem install bundler -v "$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1)" --no-document \
  && bundle config set no-cache 'true' \
  && bundle config set clean 'true'

RUN bundle config build.nokogiri --use-system-libraries
RUN bundle check \
  || bundle install --jobs $(expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1) --retry 3

# Cleanup
RUN apk del build-dependencies
RUN rm -rf /var/cache/apk/*

COPY . $APP_HOME

# Run and own only the runtime files as a non-root user for security
RUN addgroup -S -g 1000 rails \
  && adduser -S -u 1000 -G rails -h /home/rails -s /bin/bash rails \
  && chown -R rails:rails db log storage tmp

USER 1000:1000

# Used in boot.rb to disable bootsnap in docker
ENV WITHIN_DOCKER=true

EXPOSE 3000

CMD ["rails", "s", "-b", "0.0.0.0", "-p", "3000"]
