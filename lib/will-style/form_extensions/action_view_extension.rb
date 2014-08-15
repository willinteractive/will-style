# Inject helpers into default form_for / fields_for

require 'action_view/helpers'

module ActionView
  module Helpers
    module FormHelper
      def form_for_with_foundation(record, options = {}, &block)
        options[:builder] ||= WILL::Style::Foundation::FormHelper::FormBuilder
        options[:html] ||= {}
        options[:html][:class] ||= 'nice'
        form_for_without_foundation(record, options, &block)
      end

      def fields_for_with_foundation(record_name, record_object = nil, options = {}, &block)
        options[:builder] ||= WILL::Style::Foundation::FormHelper::FormBuilder
        options[:html] ||= {}
        options[:html][:class] ||= 'nice'
        options[:html][:attached_labels] = options[:attached_labels]
        fields_for_without_foundation(record_name, record_object, options, &block)
      end

      alias_method_chain :form_for, :foundation
      alias_method_chain :fields_for, :foundation
    end
  end
end

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance_tag|
  html_tag
end
