module ForemanOrchestration
  class StacksController < ::ApplicationController
    before_filter :load_compute_resources, only: [:all, :new]

    def all
      unless @compute_resources.empty?
        find_default_compute_resource
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

    def find_default_compute_resource
      @compute_resource = @compute_resources.find do |resource|
        resource.is_default
      end
      if @compute_resource
        @tenants = @compute_resource.orchestration_clients
        find_default_tenant
      end
    end

    def find_default_tenant
      @tenant = @tenants.find do |tenant|
        tenant.id == @compute_resource.default_tenant_id
      end
      if @tenant
        @stacks = @tenant.stacks
      end
    end
  end
end
