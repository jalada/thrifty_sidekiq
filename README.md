# Thrifty Sidekiq

Thrifty Sidekiq is a lightweight wrapper around a Sidekiq worker (not limited to Sidekiq) that can be used from within an existing Ruby process.

You can use it for any long running process, not just Sidekiq.

## Why?

Running a dyno for Sidekiq on a low traffic application quickly gets expensive. You can `spawn()` Sidekiq in Unicorn, but if the Sidekiq worker dies Unicorn won't know about it. 

You can link Unicorn and the Sidekiq process together, but then if your process dies too often Heroku will stop restarting it.

Thrifty Sidekiq is the answer.

## Installation

Add this line to your application's Gemfile:

    gem 'thrifty_sidekiq'

And then execute:

    $ bundle

## Example usage

1. Remove Sidekiq from your Procfile
2. In your Unicorn config `before_fork` block:

		```ruby
	    @thrifty_sidekiq ||= ThriftySidekiq.start!
	    ```

Now when your Unicorn server starts, Thrifty Sidekiq will start 1 Sidekiq worker using the command `bundle exec sidekiq`. If you want to use a custom command to start Sidekiq (or a similar worker) pass it in as the first argument to `start!`.

You must use a conditional variable assignment to stop Thrifty Sidekiq being started n times, where n is the number of Unicorn workers. Let me know if there's a better way of doing this.

**Do not** start Thrifty Sidekiq in code that will be run by the command you are spawning (e.g. in your Sidekiq configuration or Rails initializer). This will have a 'fork bomb' effect as each worker starts another instance of Thrifty Sidekiq, starting another worker, starting another instance...

## How does it work?

```
       Unicorn
          |
          V
   Thrifty Sidekiq
          |
          V
      Supervisor
          |
          V
 Assistant Supervisor
          |
          V
       Manager
          |
          V
   Sidekiq process
```

When the Sidekiq process quits, the Manager raises an exception. This is trapped by the assistant supervisor which sleeps (to avoid thrashing) before raising an exception itself. The supervisor (which is a Celluloid supervisor) then restarts the Assistant Supervisor (which restart the manager, which restarts the Sidekiq process).

## Contributing

1. Fork it ( https://github.com/jalada/thrifty_sidekiq/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
