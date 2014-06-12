module ThriftySidekiq

  class Supervisor

    def initialize(sidekiq_command, auto_start=false)
      @sidekiq_command = sidekiq_command
      start! if auto_start
    end

    def start!
      @assistant = AssistantSupervisor.supervise(@sidekiq_command)
    end

  end

end
