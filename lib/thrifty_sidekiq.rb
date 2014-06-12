require 'thrifty_sidekiq/version'
require 'thrifty_sidekiq/manager'
require 'thrifty_sidekiq/assistant_supervisor'
require 'thrifty_sidekiq/supervisor'

# Supervisor -> AssistantSupervisor -> Manager

module ThriftySidekiq
  def self.start!(sidekiq_command='bundle exec sidekiq')
    Supervisor.new sidekiq_command, true
  end
end
