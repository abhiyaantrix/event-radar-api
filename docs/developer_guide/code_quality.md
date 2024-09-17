# Code Quality

For every project maintainability and consistent code styles, security and best practices are key factors.

Each commit is linted and tested to ensure code quality, security and best practices at several levels,
as pre-commit hooks and CI/CD pipelines.

All the same tools can also be executed manually on-demand.

## Code quality and best practices

```bash
# Single point to auto fix all linting issues
# It will also run rubocop
npm run lint:fix

# Execute rubocop manually
# Linting and static code analysis
rubocop -A
```

There are additional static analyzers for code smells and security vulnerabilities.

1. [Rubocop](https://rubocop.org/) is configured as Ruby linter
2. [Bullet](https://github.com/flyerhzm/bullet) is configured to detect N+1 queries and unused eager loading
3. [Reek](https://github.com/troessner/reek) is configured to detect code smells
4. [Traceroute](https://github.com/amatsuda/traceroute) is configured to detect unused routes and actions
5. [Bundler audit](https://github.com/rubysec/bundler-audit) is configured to detect vulnerabilities in Ruby gems
6. [Rails best practices](https://github.com/flyerhzm/rails_best_practices) is configured to detect best practices violations
7. [Brakeman](https://brakemanscanner.org/) is configured to detect security vulnerabilities

```bash
bundle exec rails_best_practices
bundle exec reek
bundle exec rake tracerout
bundle exec bundle-audit check
bundle exec brakeman -A
```

Execute all at once

```bash
npm run lint:ruby
```

## Commit messages

We use [commitlint](https://commitlint.js.org) to enforce commit message best practices.

```bash
# Check commit message format
npm run lint:commit

# Check commit message format from specific commit
npm run lint:commit:head
```

## Node scripts

We are using [Husky](https://typicode.github.io/husky/)
and [lint-staged](https://github.com/okonet/lint-staged) to run scripts before committing to ensure
that code style and best practices auto fixed before commit is pushed to remote and save time.

```bash
# Run all node scripts
npm run lint

# or
npm run lint:fix
```

All Node.js scripts are located in [package.json](../../package.json) and can be executed using npm.
