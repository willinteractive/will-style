# Inject helpers into default form_for / fields_for

require 'action_view/helpers'

module FormHelperWithFoundation
  def form_for(record, options = {}, &block)
    options[:builder] ||= WILL::Style::Foundation::FormHelper::FormBuilder
    options[:html] ||= {}
    options[:html][:class] ||= 'nice'

    super(record, options, &block)
  end

  def fields_for(record_name, record_object = nil, options = {}, &block)
    options[:builder] ||= WILL::Style::Foundation::FormHelper::FormBuilder
    options[:html] ||= {}
    options[:html][:class] ||= 'nice'
    options[:html][:attached_labels] = options[:attached_labels]

    super(record_name, record_object, options, &block)
  end
end

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance_tag|
  html_tag
end


ActionView::Helpers::FormHelper.send(:prepend, FormHelperWithFoundation)