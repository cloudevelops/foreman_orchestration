module ForemanOrchestration
  class StackTemplatesController < ::ApplicationController
    before_filter :find_resource, only: [:edit, :update, :destroy, :with_params]

    def index
      @templates = StackTemplate.order(:name).all
    end

    def new
      @template = StackTemplate.new
    end

    # TODO: there is an API for template validation:
    # http://developer.openstack.org/api-ref-orchestration-v1.html#template_validate
    # Maybe we can use it here?
    def create
      @template = StackTemplate.new(template_params)
      if @template.save
        process_success object: @template
      else
        process_error object: @template
      end
    end

    def update
      if @template.update_attributes(template_params)
        process_success object: @template
      else
        process_error object: @template
      end
    end

    def destroy
      if @template.destroy
        process_success object: @template
      else
        process_error object: @template
      end
    end

    # ajax methods
    def with_params
      render partial: 'with_params', locals: {template: @template, parameters: {}}
    end

    private

    def template_params
      params.fetch(:foreman_orchestration_stack_template)
        .slice(:name, :template)
    end

    def find_resource
      @template = StackTemplate.find(params[:id])
    end
  end
end
