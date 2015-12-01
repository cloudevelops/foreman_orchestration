module ForemanOrchestration
  class Stack
    include ActiveModel::Validations
    include ActiveModel::Conversion

    attr_accessor :id, :compute_resource_id, :tenant_id, :name, :template_id
    attr_accessor :parameters

    validates :compute_resource_id, presence: true
    validates :tenant_id, presence: true
    validates :name, presence: true, format: {with: /^[a-zA-Z][a-zA-Z0-9_.-]*$/}
    validates :template_id, presence: true

    def initialize(params = {})
      @id = params[:id]
      @compute_resource_id = params[:compute_resource_id]
      @tenant_id = params[:tenant_id]
      @name = params[:name]
      @template_id = params[:template_id]
      @parameters = params[:parameters] || {}
    end

    def persisted?
      false
    end

    def save
      if valid?
        tenant.create_stack(self)
      else
        false
      end
    end

    def destroy
      tenant.delete_stack(self)
    end

    def template
      if template_id
        @template ||= StackTemplate.find(template_id)
      end
    end

    def template_body
      if template
        YAML.load(template.template)
      end
    end

    def tenant
      if tenant_id && compute_resource
        @tenant ||= compute_resource.orchestration_client_for(tenant_id)
      end
    end

    def compute_resource
      if compute_resource_id
        @compute_resource ||= ::ComputeResource.find(compute_resource_id)
      end
    end

    def tenants
      # TODO: find a better place for this method
      if compute_resource
        @tenants ||= compute_resource.orchestration_clients
      end
    end
  end
end

