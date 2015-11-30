module ForemanOrchestration
  class Stack
    include ActiveModel::Validations
    include ActiveModel::Conversion

    attr_accessor :compute_resource_id, :tenant_id, :name, :template_id, :parameters

    validates :compute_resource_id, presence: true
    validates :tenant_id, presence: true
    validates :name, presence: true, format: {with: /^[a-zA-Z][a-zA-Z0-9_.-]*$/}
    validates :template_id, presence: true

    def initialize(params = {})
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
      all_stacks = compute_resource.stacks_for_tenant(tenant)
      stack = all_stacks.find { |s| s.stack_name == name }
      if stack
        compute_resource.delete_stack(tenant, stack)
      else
        message = "Cannot find stack '#{name}' in tenant '#{tenant}'"
        raise ActiveRecord::RecordNotFound, message
      end
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

