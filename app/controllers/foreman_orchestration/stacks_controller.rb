module ForemanOrchestration
  class StacksController < ::ApplicationController
    def index
      # TODO: use model here
      # - id
      # - name
      # - status
      # - creation_time
      # - updated_time
      @stacks = [
        {name: 'Some stack 1', status: 'active', id: '90wefhshdfjgsu675', creation_time: Time.now - 1.days, updated_time: Time.now},
        {name: 'Some stack 2', status: 'active', id: '90wefhshdfjgsu675', creation_time: Time.now - 2.days, updated_time: Time.now},
        {name: 'Some stack 3', status: 'active', id: '90wefhshdfjgsu675', creation_time: Time.now - 3.days, updated_time: Time.now},
        {name: 'Some stack 4', status: 'active', id: '90wefhshdfjgsu675', creation_time: Time.now - 4.days, updated_time: Time.now},
        {name: 'Some stack 5', status: 'active', id: '90wefhshdfjgsu675', creation_time: Time.now - 5.days, updated_time: Time.now}
      ].map { |s| OpenStruct.new s }
    end

    def new
    end

    def create
    end
  end
end
