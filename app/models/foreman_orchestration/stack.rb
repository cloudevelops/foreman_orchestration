module ForemanOrchestration
  class Stack
    include ActiveModel::Validations
    include ActiveModel::Conversion

    attr_accessor :compute_resource, :tenant, :name, :template_id, :parameters

    validates :compute_resource, presence: true
    validates :tenant, presence: true
    validates :name, presence: true, format: {with: /^[a-zA-Z][a-zA-Z0-9_.-]*$/}
    validates :template_id, presence: true

    def initialize(params = {})
      @compute_resource = params[:compute_resource]
      @tenant = params[:tenant]
      @name = params[:name]
      @template_id = params[:template_id]
      @parameters = params[:parameters]
    end

    def persisted?
      false
    end

    def save
      if valid?
        params = {
          stack_name: name,
          template: load_yaml_template,
          parameters: parameters
        }
        compute_resource.create_stack(tenant, params)
      else
        false
      end
    end

    def compute_resource_tenants
      compute_resource.tenants
    end

    def template
      if template_id
        @template ||= StackTemplate.find(template_id)
      end
    end

    private

    def load_yaml_template
      StackTemplate.find(template_id).template
    end
  end
end

