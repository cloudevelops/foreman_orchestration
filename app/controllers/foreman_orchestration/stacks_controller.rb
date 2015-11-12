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
    end

    def create
    end

    # ajax methods
    def for_tenant
      # compute_resource = Foreman::Model::Openstack.first
      # compute_resource.stacks_for_tenant(params[:tenant])
      stub_stacks_ajax
      render partial: 'foreman_orchestration/stacks/stacks'
      # TODO: what to do with errors? (incorrect tenant name etc.)
    end

    private

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
