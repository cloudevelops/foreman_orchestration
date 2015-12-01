module ForemanOrchestration
  class OrchestrationClient
    extend Forwardable
    def_delegators :@tenant, :id, :name, :description, :enabled

    def initialize(tenant, credentials)
      @tenant = tenant
      @credentials = credentials
    end

    def stacks
      client.stacks
    end

    def create_stack(stack)
      params = {
        files: {},
        disable_rollback: true,
        parameters: stack.parameters,
        stack_name: stack.name,
        environment: {},
        template: stack.template_body
      }
      client.create_stack(params)
    end

    def delete_stack(stack)
      fog_model = fog_model_for_stack(stack.id)
      client.delete_stack(fog_model)
    end

    private

    def credentials
      @credentials.merge(openstack_tenant: name)
    end

    def client
      @client ||= Fog::Orchestration.new(credentials)
    end

    def fog_model_for_stack(id)
      model = stacks.find { |s| s.id == id }
      if model
        model
      else
        raise "Cannot find a stack with the specified id: #{id}"
      end
    end
  end
end
