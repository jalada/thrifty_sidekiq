module ThriftySidekiq

  class AssistantSupervisor
    include Celluloid
    trap_exit :manager_died

    class ManagerDiedError < StandardError; end

    def initialize(sidekiq_command)
      @manager = Manager.new_link(sidekiq_command)
      @manager.async.start_sidekiq!
    end

    def manager_died(manager, reason)
      puts "Oh no! #{manager.inspect} died because #{reason.class}"
      puts "Waiting for 5 seconds..."
      sleep 5
      raise ManagerDiedError
    end

  end
end
