module ForemanOrchestration
  class StackTemplate < ActiveRecord::Base
    attr_accessible :name, :template

    validates :name, presence: true
    validates :template, presence: true

    validate do
      begin
        YAML.load(template)
      rescue Psych::SyntaxError
        errors.add(:template, 'Provided template is not a valid YAML file')
      end
    end

    def self.for_select_tag
      select([:id, :name]).order(:name).all
    end

    def template_parameters
      @template_parameters ||= parse_parameters
    end

    private

    def parse_parameters
      yaml = YAML.load(template)
      yaml['parameters']
    end
  end
end
