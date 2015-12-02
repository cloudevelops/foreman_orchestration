module ForemanOrchestration
  module OpenstackExtensions
    extend ActiveSupport::Concern

    def orchestration_clients
      # TODO: select only enabled: true tenants?
      @orchestration_clients ||= tenants.map do |t|
        create_orchestration_client(t)
      end
    end

    def orchestration_client_for(tenant_id)
      orchestration_clients.find { |client| client.id == tenant_id }
    end

    def create_orchestration_client(tenant)
      ForemanOrchestration::OrchestrationClient.new(tenant, fog_credentials)
    end

    def is_default
      attrs[:is_default]
    end

    def mark_as_default
      ActiveRecord::Base.transaction do
        self.class.all.each do |record|
          record.attrs[:is_default] = false
          record.save!
        end
        attrs[:is_default] = true
        save!
      end
    end

    def default_tenant_id
      attrs[:default_tenant_id]
    end

    def default_tenant_id=(tenant_id)
      attrs[:default_tenant_id] = tenant_id
    end

    def default_tenant
      if default_tenant_id
        orchestration_client_for(default_tenant_id)
      else
        orchestration_clients.first
      end
    end
  end
end
