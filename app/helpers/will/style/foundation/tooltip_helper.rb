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
      # Helpers for generating Foundation tooltips
      module TooltipHelper

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
        # You can use any of the html options available in ActionView helpers.
        #
        # = Examples
        #   <%= f_tooltip "Click Here", "This takes you to a new place", "top", class: "round", options: "disable_for_touch:true" %>
        #
        def f_tooltip(text="", title="", position="bottom", options={})
          # Merge custom html data options with mandatory tooltip data options
          if options[:data] && options[:data].is_a?(Hash)
            options[:data] = options[:data].merge({ tooltip: true })
          else
            options[:data] = { tooltip: true }
          end

          options[:title] = title

          # Merge custom classes with mandatory classes
          options[:class] = "has-tip tip-#{position} #{options[:class]}"

          content_tag(:span, options) do
            text
          end
        end
      end
    end
  end
end
