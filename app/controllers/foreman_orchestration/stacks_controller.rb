module ForemanOrchestration
  class StacksController < ::ApplicationController
    before_filter :load_compute_resources, only: [:all, :new]

    def all
      @compute_resource = default_compute_resource(@compute_resources)
      if @compute_resource
        @tenants = @compute_resource.orchestration_clients
        @tenant = @compute_resource.default_tenant
        @stacks = @tenant.stacks if @tenant
      end
    end

    def index
      @compute_resource = ::ComputeResource.find(params[:compute_resource_id])
      @tenant = @compute_resource.orchestration_client_for(params[:tenant_id])
      @stacks = @tenant.stacks
      render layout: !ajax?
    end

    def new
      @stack = Stack.new(compute_resource_id: params[:compute_resource_id],
                         tenant_id: params[:tenant_id])
    end

    def create
      @stack = Stack.new(stack_params)
      if @stack.save
        flash[:notice] = "Stack '#{@stack.name}' is being created now"
        redirect_to all_stacks_path
      else
        load_compute_resources
        process_error object: @stack
      end
    end

    def destroy
      @stack = Stack.new(compute_resource_id: params[:compute_resource_id],
                         tenant_id: params[:tenant_id],
                         id: params[:id])
      @stack.destroy
      redirect_to all_stacks_path, notice: 'Stack is being deleted now'
    end

    private

    def stack_params
      params.fetch(:foreman_orchestration_stack)
        .slice(:compute_resource_id, :tenant_id, :name, :template_id, :parameters)
    end

    def load_compute_resources
      @compute_resources = ::Foreman::Model::Openstack.all
    end

    def default_compute_resource(compute_resources)
      compute_resources.find(&:is_default) || compute_resources.first
    end
  end
end
