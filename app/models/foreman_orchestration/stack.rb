module ForemanOrchestration
  class Stack
    include ActiveModel::Validations
    include ActiveModel::Conversion

    attr_accessor :compute_resource, :tenant_id, :name, :template_id, :parameters

    validates :compute_resource, presence: true
    validates :tenant_id, presence: true
    validates :name, presence: true, format: {with: /^[a-zA-Z][a-zA-Z0-9_.-]*$/}
    validates :template_id, presence: true

    def initialize(params = {})
      @compute_resource = params[:compute_resource]
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
        params = {
          files: {},
          disable_rollback: true,
          parameters: parameters,
          stack_name: name,
          environment: {},
          template: load_yaml_template
        }
        compute_resource.create_stack(tenant, params)
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

    def tenant
      @tenant ||= compute_resource.orchestration_client_for(tenant_id)
    end

    private

    def load_yaml_template
      template = StackTemplate.find(template_id).template
      YAML.load(template)
    end
  end
end

