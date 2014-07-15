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
      # :exclude_close_button - will not include the close button.
      #
      # +block+
      #
      # ERB Block for the alert text if it needs to be HTML content.
      #
      # = Examples
      # Default Functionality
      #   <%= f_alert("This is an alert", "warning", class: "round", exclude_close_button: true) %>
      # With ERB Block
      #   <%= f_alert("warning" do %>
      #     <h1>Big Alert</h1>
      #   <% end %>
      #
      def f_alert(text="", type="info", options={}, &block)
        if block
          content = capture(&block)

          options = options.merge(type)
          type = text
        else
          content = content_tag(:span, text)
        end

        content_tag(:div, data: { alert: true }, class: "alert-box #{type} #{options[:class]}") do
          if options[:exclude_close_button] == true
            content
          else
            content + link_to("&times;".html_safe, "#", class: "close")
          end
        end
      end
    end
  end
end
