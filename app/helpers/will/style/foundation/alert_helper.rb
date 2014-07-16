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
    module Foundation

      ##
      # Helpers for generating Foundation alerts
      module AlertHelper

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
        # :id – element id.
        #
        # :class – will add classes to the alert. 
        #
        # :dismissable - whether or not to include the close button. Defaults to false.
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
          if block_given?
            content = capture(&block)

            options = options.merge(type) if type.is_a?(Hash)
            type = text
          else
            content = content_tag(:span, text)
          end

          content_tag(:div, data: { alert: true }, class: "alert-box #{type} #{options[:class]}", id: options[:id]) do
            if options.has_key?(:dismissable) && options[:dismissable] == true
              content + link_to("&times;".html_safe, "#", class: "close")
            else
              content            
            end
          end
        end
      end
    end
  end
end
