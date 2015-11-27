module ForemanOrchestration
  module OpenstackExtensions
    extend ActiveSupport::Concern

    def orchestration_clients
      # TODO: select only enabled: true tenants?
      tenants.map do |t|
        ForemanOrchestration::OrchestrationClient.new(t, fog_credentials)
      end
    end

    def orchestration_client_for(tenant_id)
      tenant = tenants.find { |t| t.id == tenant_id }
      if tenant
        ForemanOrchestration::OrchestrationClient.new(tenant, fog_credentials)
      else
        raise ActiveRecord::RecordNotFound, "Cannot find tenant: id='#{tenant_id}'"
      end
    end
  end
end
