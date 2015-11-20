module ForemanOrchestration
  class StacksController < ::ApplicationController
    def index
      # TODO: for demo it is just the first one compute resource
      # TODO: but we have to change it later
      compute_resource = default_compute_resource
      # TODO: select only enabled: true tenants?
      @tenants = compute_resource.tenants
      @tenant = compute_resource.tenant
      @stacks = compute_resource.stacks
    end

    def new
      @stack = Stack.new(compute_resource: default_compute_resource)
    end

    def create
      @stack = Stack.new(new_stack_params)
      if @stack.save
        process_success object: @stack,
                        success_msg: "Stack #{@stack.name} is being created now"
      else
        process_error object: @stack
      end
    end

    def destroy_stack
      @stack = Stack.new(
        compute_resource: default_compute_resource,
        name: params[:name],
        tenant: params[:tenant]
      )
      if @stack.destroy
        process_success object: @stack
      else
        process_error object: @stack
      end
    end

    # ajax methods
    def for_tenant
      # TODO: what to do with errors? (incorrect tenant name etc.)
      compute_resource = default_compute_resource
      @tenant = params[:tenant]
      @stacks = compute_resource.stacks_for_tenant(@tenant)
      render partial: 'stacks'
    end

    def params_for_template
      template = StackTemplate.find(params[:template_id])
      render partial: 'params', locals: {template: template, parameters: {}}
    end

    private

    def new_stack_params
      params.fetch(:foreman_orchestration_stack)
        .slice(:tenant, :name, :template_id, :parameters)
        .merge(compute_resource: default_compute_resource)
    end

    def default_compute_resource
      Foreman::Model::Openstack.first
    end
  end
end
