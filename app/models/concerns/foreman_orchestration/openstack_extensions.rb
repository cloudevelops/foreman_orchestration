module ForemanOrchestration
  module OpenstackExtensions
    extend ActiveSupport::Concern

    included do
      delegate :stacks, :to => :orchestration_client
    end

    def stacks_for_tenant(tenant)
      credentials = fog_credentials.merge(openstack_tenant: tenant)
      client = make_orchestration_client(credentials)
      client.stacks
    end

    def create_stack(tenant, params)
      credentials = fog_credentials.merge(openstack_tenant: tenant)
      client = make_orchestration_client(credentials)
      client.create_stack(params)
    end

    def delete_stack(tenant, stack)
      credentials = fog_credentials.merge(openstack_tenant: tenant)
      client = make_orchestration_client(credentials)
      client.delete_stack(stack)
    end

    private

    def orchestration_client
      @orchestration_client ||= make_orchestration_client(fog_credentials)
    end

    def make_orchestration_client(credentials)
      Fog::Orchestration.new(credentials)
    end
  end
end
