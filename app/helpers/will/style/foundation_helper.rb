##
# Namespace module.
#
module WILL
  ##
  # Namespace module.
  #
  module Style
    ##
    # Helpers for generating Foundation HTML elements
    module FoundationHelper
      ##
      # Generates an alert box. You can either specify alert text
      # or use an ERB Block to fill in HTML content.
      # = Params
      # +text+
      #
      # text you would like to display in the alert box.
      #
      # +type+
      #
      # Type of alert. 
      #
      # <i>Possible values</i>: success, warning, info, alert, secondary. 
      #
      # <i>Default value</i>: info.
      #
      # +options+
      #
      # Hash of options.
      #
      # :class – will add classes to the alert. 
      #
      # :dismissable - whether or not to include the close button. Defaults to true.
      #
      # +block+
      #
      # ERB Block for the alert text if it needs to be HTML content.
      #
      # = Examples
      # Default Functionality
      #   <%= f_alert "This is an alert", "warning", class: "round", dismissable: false %>
      # With ERB Block
      #   <%= f_alert "warning" do %>
      #     <h1>Big Alert</h1>
      #   <% end %>
      #
      def f_alert(text="", type="info", options={}, &block)
        if block
          content = capture(&block)

          options = options.merge(type) if type.is_a?(Hash)
          type = text
        else
          content = content_tag(:span, text)
        end

        content_tag(:div, data: { alert: true }, class: "alert-box #{type} #{options[:class]}") do
          if options.has_key?(:dismissable) && options[:dismissable] == false
            content
          else
            content + link_to("&times;".html_safe, "#", class: "close")
          end
        end
      end

      ##
      # Generates a tooltip span.
      # = Params
      # +text+
      #
      # text you would like to display in the span.
      #
      # +title+
      #
      # tooltip text.
      #
      # +position+
      #
      # Position of the tooltip.
      #
      # <i>Possible values</i>: bottom, top, left, right. 
      #
      # <i>Default value</i>: bottom.
      #
      # +options+
      #
      # Hash of options.
      #
      # :class – will add classes to the tooltip. 
      #
      # :options - Foundation tooltip data-options. (disable_for_touch:true, show_on:large)
      #
      # = Examples
      #   <%= f_tooltip "Click Here", "This takes you to a new place", "top", class: "round", options: "disable_for_touch:true" %>
      #
      def f_tooltip(text="", title="", position="bottom", options={})
        content_tag(:span, data: { tooltip: true, options: options[:options] }, class: "has-tip tip-#{position} #{options[:class]}", title: title) do
          text
        end
      end
    end
  end
end
