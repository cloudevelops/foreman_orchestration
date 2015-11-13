module ForemanOrchestration
  class StacksController < ::ApplicationController
    def index
      # TODO: for demo it is just the first one compute resource
      # TODO: but we have to change it later
      # compute_resource = Foreman::Model::Openstack.first
      # TODO: select only enabled: true tenants?
      # @tenants = compute_resource.tenants
      # @tenant = compute_resource.tenant
      # @stacks = compute_resource.stacks
      stub_tenants
      stub_stacks
    end

    def new
      # compute_resource = Foreman::Model::Openstack.first
      # @tenants = compute_resource.tenants
      # @tenant = compute_resource.tenant
      stub_tenants
    end

    # params:
    # - tenant name
    # - stack_name (^[a-zA-Z][a-zA-Z0-9_.-]*$)
    # - template
    # - parameters
    def create
      @stack = Stack.new(new_stack_params)
      if @stack.save
        redirect_to stacks_path, notice: 'Stack is being created now'
      else
        @tenants = @stack.compute_resource.tenants
        flash.now[:error] = 'Unable to create a new stack: check all requried fields'
        render :new
      end
    end

    # ajax methods
    def for_tenant
      # compute_resource = Foreman::Model::Openstack.first
      # compute_resource.stacks_for_tenant(params[:tenant])
      stub_stacks_ajax
      render partial: 'foreman_orchestration/stacks/stacks'
      # TODO: what to do with errors? (incorrect tenant name etc.)
    end

    def params_for_template
      # TODO: need to simplify this
      stub_tenants
      @template = StackTemplate.find(params[:template_id])
      render partial: 'form'
    end

    private

    def new_stack_params
      params.fetch(:stack)
        .slice(:tenant, :name, :template_id, :parameters)
        .merge(compute_resource: default_compute_resource)
    end

    def default_compute_resource
      Foreman::Model::Openstack.first
    end

    def stub_tenants
      @tenants = [
        {
          id: '12345',
          name: 'sandbox'
        },
        {
          id: '45678',
          name: 'infra'
        },
        {
          id: '67890',
          name: 'omg'
        }
      ].map { |h| OpenStruct.new h }
      @tenant = 'sandbox'
    end

    def stub_stacks
      @stacks = [
        {
          stack_name: 'monitoring-1',
          description: 'some monitoring',
          stack_status: 'COMPLETED',
          stack_status_reason: 'some reason',
          creation_time: Time.now,
          updated_time: nil
        },
        {
          stack_name: 'storage-1',
          description: 'some storage',
          stack_status: 'COMPLETED',
          stack_status_reason: 'some reason',
          creation_time: Time.now,
          updated_time: nil
        },
        {
          stack_name: 'streaming-1',
          description: 'some streaming',
          stack_status: 'COMPLETED',
          stack_status_reason: 'cool',
          creation_time: Time.now,
          updated_time: nil
        }
      ].map { |h| OpenStruct.new h }
    end

    def stub_stacks_ajax
      @stacks = [
        {
          stack_name: 'cool-1',
          description: 'some cool stack',
          stack_status: 'COMPLETED',
          stack_status_reason: 'some reason',
          creation_time: Time.now,
          updated_time: nil
        },
        {
          stack_name: 'doge-1',
          description: 'some doge stack',
          stack_status: 'COMPLETED',
          stack_status_reason: 'such reason wow',
          creation_time: Time.now,
          updated_time: nil
        }
      ].map { |h| OpenStruct.new h }
    end
  end
end
