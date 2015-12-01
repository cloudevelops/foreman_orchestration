module ForemanOrchestration
  class TenantsController < ::ApplicationController
    before_filter :ajax_request, only: [:default]
    before_filter :find_compute_resource, only: [:for_select, :default]

    def for_select
      @tenants = @compute_resource.tenants
      render partial: 'for_select'
    end

    def default
      tenant = @compute_resource.orchestration_client_for(params[:tenant_id])
      @compute_resource.default_tenant_id = tenant.id
      @compute_resource.save!
      respond_to do |format|
        format.json { render :json => {}, :status => :ok }
      end
    end

    private

    def find_compute_resource
      @compute_resource = ::Foreman::Model::Openstack.find(params[:compute_resource_id])
    end
  end
end
