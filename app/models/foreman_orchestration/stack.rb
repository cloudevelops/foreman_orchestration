module ForemanOrchestration
  class Stack < Foreman::Model::Openstack
    def self.all_stacks
      all.flat_map(&:stacks)
    end

    def stacks
      # TODO: needs to be tested, maybe this method cannot be directly used
      # on the client
      client.all
    end
  end
end
