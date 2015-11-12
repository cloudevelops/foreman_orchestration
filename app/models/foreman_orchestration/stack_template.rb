module ForemanOrchestration
  class StackTemplate < ActiveRecord::Base
    attr_accessible :name, :template

    validates :name, presence: true
    validates :template, presence: true
  end
end
