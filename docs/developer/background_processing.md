# Background processing

For long running asynchronous jobs, we use [Sidekiq](https://github.com/sidekiq/sidekiq)

For any long running work such as external API integrations, heavy lifting is delegated to background jobs.
This allows us to respond to requests quickly and also to handle large number of requests concurrently.

## Adding a new job

1. Create a new job class in `app/jobs/`
2. Use ActiveJob's `perform_later` to enqueue the job

```ruby
MyJob.perform_later(arg1, arg2)
```

## Sidekiq Web Interface

Sidekiq provides a web interface for monitoring and managing jobs.

```bash
# Start the Sidekiq server
bundle exec sidekiq

# Access the web interface
http://localhost:3000/sidekiq
```

## Sidekiq configuration

Redis is used as message broker / queue to store the jobs and their status.

Check [Sidekiq initializer](../../config/initializers/sidekiq.rb) for more details.

## Scheduling jobs

<!-- TODO: Add more details about Sidekiq scheduler -->
