module ForemanOrchestration
  module ComputeResourcesControllerExtensions
    extend ActiveSupport::Concern

    included do
      before_filter :ajax_request, only: [:default]
    end

    def default
      Foreman::Model::Openstack.find(params[:id])
        .mark_as_default
      respond_to do |format|
        format.json { render :json => {}, :status => :ok }
      end
    end
  end
end
