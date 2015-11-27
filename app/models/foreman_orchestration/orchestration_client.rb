module ForemanOrchestration
  class OrchestrationClient
    extend Forwardable
    def_delegators :@tenant, :id, :name, :description, :enabled

    def initialize(tenant, credentials)
      @tenant = tenant
      @credentials = credentials
    end

    def stacks
      # client.stacks
      [
        {
          id: 'some-id-6664',
          stack_name: 'some',
          description: 'ma cool stack',
          stack_status: 'SMOKIN',
          creation_time: Time.now - 2.days,
          updated_time: Time.now - 1.day
        }
      ].map { |r| OpenStruct.new r }
    end

    def create_stack
      # TODO:
      # client.create_stack(params)
    end

    def delete_stack
      # TODO:
      # client.delete_stack(stack)
    end

    private

    def credentials
      @credentials.merge(openstack_tenant: name)
    end

    def client
      @client ||= Fog::Orchestration.new(credentials)
    end
  end
end
