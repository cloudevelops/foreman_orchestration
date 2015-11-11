module ForemanOrchestration
  class StacksController < ::ApplicationController
    def index
      # TODO: for demo it is just the first one compute resource
      # TODO: but we have to change it later
      compute_resource = Foreman::Model::Openstack.first
      @stacks = compute_resource.stacks
    end

    def new
    end

    def create
    end
  end
end
