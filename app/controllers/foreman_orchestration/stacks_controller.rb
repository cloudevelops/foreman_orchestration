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

    # ajax methods
    def for_tenant
      # compute_resource = Foreman::Model::Openstack.first
      # compute_resource.stacks_for_tenant(params[:tenant])
      stub_stacks_ajax
      render partial: 'foreman_orchestration/stacks/stacks'
      # TODO: what to do with errors? (incorrect tenant name etc.)
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
      # Foreman::Model::Openstack.first
      stub_compute_resource
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

    def stub_compute_resource
      stub_tenants
      OpenStruct.new(tenants: @tenants, tenant: @tenant)
    end
  end
end
