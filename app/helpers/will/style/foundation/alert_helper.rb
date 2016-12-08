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
    #
    module Foundation

      ##
      # Helpers for generating Foundation alerts
      #
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
        # You can use any of the html options available in ActionView helpers.
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
            content = text.html_safe
          end

          # Merge custom html data options with mandatory alert data options
          if options[:data] && options[:data].is_a?(Hash)
            options[:data] = options[:data].merge({ alert: true, "no-turbolink" => true })
          else
            options[:data] = { alert: true, "no-turbolink" => true }
          end

          # Merge custom classes with mandatory classes
          options[:class] = "alert-box #{type} #{options[:class]}"

          content_tag(:div, options) do
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
