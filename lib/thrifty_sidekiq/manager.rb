require 'celluloid'

module ThriftySidekiq

  # A manager looks after a Sidekiq worker.
  class Manager
    include Celluloid

    class SidekiqDiedError < StandardError; end

    def initialize(sidekiq_command)
      @sidekiq_command = sidekiq_command
      puts "ThriftySidekiq::Manager started"
    end

    def start_sidekiq!
      puts "Running #{@sidekiq_command}..."
      sidekiq_pid = spawn(@sidekiq_command)
      Process.wait(sidekiq_pid)
      raise SidekiqDiedError
    end

  end

end
