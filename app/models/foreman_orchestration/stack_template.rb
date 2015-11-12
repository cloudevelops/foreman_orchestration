module ForemanOrchestration
  class StackTemplate < ActiveRecord::Base
    attr_accessible :name, :template

    validates :name, presence: true
    validates :template, presence: true

    def self.for_select_tag
      select([:id, :name]).order(:name).all
    end
  end
end
