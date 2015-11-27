module ForemanOrchestration
  class TenantsController < ::ApplicationController
    def for_select
      @compute_resource = ::ComputeResource.find(params[:compute_resource_id])
      @tenants = @compute_resource.tenants
      render partial: 'for_select'
    end
  end
end
