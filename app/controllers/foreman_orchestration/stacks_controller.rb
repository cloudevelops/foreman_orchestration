module ForemanOrchestration
  class StacksController < ::ApplicationController
    before_filter :load_compute_resources, only: [:all, :new]

    def all
      unless @compute_resources.empty?
        @compute_resource = @compute_resources.first
        @tenants = @compute_resource.orchestration_clients
        unless @tenants.empty?
          @tenant = @tenants.find { |t| t.name == @compute_resource.tenant }
          @stacks = @tenant.stacks
        end
      end
    end

    def index
      @compute_resource = ::ComputeResource.find(params[:compute_resource_id])
      @tenant = @compute_resource.orchestration_client_for(params[:tenant_id])
      @stacks = @tenant.stacks
      render layout: false
    end

    def new
      @compute_resource = ::ComputeResource.find_by_id(params[:compute_resource_id])
      if @compute_resource
        @tenants = @compute_resource.orchestration_clients
        @tenant = @tenants.find { |t| t.id == params[:tenant_id] }
      end
      @stack = Stack.new(compute_resource: @compute_resource)
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

    def destroy
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

    private

    def new_stack_params
      params.fetch(:foreman_orchestration_stack)
        .slice(:compute_resource_id, :tenant_id, :name, :template_id, :parameters)
    end

    def load_compute_resources
      @compute_resources = ::Foreman::Model::Openstack.all
    end
  end
end
