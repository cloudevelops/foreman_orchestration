module ForemanOrchestration
  module LayoutHelperExtensions
    extend ActiveSupport::Concern

    def selectable_tag(name, options_tags = nil, options = {})
      content_tag(:div, :class => 'clearfix') do
        content_tag(:div, :class => 'form-group') do
          label = label_tag(name, options.delete(:label), :class => 'col-md-3 control-label')
          help = help_inline(:indicator, '')
          add_help_to_label('col-md-4', label, help) do
            addClass options, 'form-control'
            select_tag name, options_tags, options
          end
        end
      end
    end
  end
end
