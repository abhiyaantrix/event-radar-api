# frozen_string_literal: true

Oj.optimize_rails

default_options = {
  mode: :compat # Standard JSON compatibility
}

# Pretty print in development
default_options[:indent] = 2 if Rails.env.development?

Oj.default_options = Oj.default_options.merge(default_options)
