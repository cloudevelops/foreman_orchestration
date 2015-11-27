module ForemanOrchestration
  class StacksController < ::ApplicationController
    def all
      @compute_resources = Foreman::Model::Openstack.all
      unless @compute_resources.empty?
        @compute_resource = @compute_resources.first
        @tenants = @compute_resource.orchestration_clients
      end
    end

    def index
      @compute_resource = find_compute_resource
      @tenant = @compute_resource.orchestration_client_for(params[:tenant_id])
      @stacks = @tenant.stacks
      render layout: false
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
      # TODO: compute_resource_id
      @stack = Stack.new(
        compute_resource: default_compute_resource,
        name: params[:name],
        tenant: params[:tenant]
      )
      @stack.destroy
      redirect_to stacks_path, notice: "Stack #{@stack.name} is being deleted now"
    end

    # ajax methods
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

    def find_compute_resource
      ComputeResource.find(params[:compute_resource_id])
    end
  end
end
