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

    def create_stack
      # TODO: delegate?
    end

    def destroy_stack
      # TODO: delegate?
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
