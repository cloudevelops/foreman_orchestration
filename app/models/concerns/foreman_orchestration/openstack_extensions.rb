module ForemanOrchestration
  module OpenstackExtensions
    extend ActiveSupport::Concern

    included do
      delegate :stacks, :to => :orchestration_client
    end

    private

    def orchestration_client
      @orchestration_client ||= Fog::Orchestration.new(fog_credentials)
    end
  end
end
