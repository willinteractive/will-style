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
        # :id – element id.
        #
        # :class – will add classes to the tooltip. 
        #
        # :options - Foundation tooltip data-options. (disable_for_touch:true, show_on:large)
        #
        # = Examples
        #   <%= f_tooltip "Click Here", "This takes you to a new place", "top", class: "round", options: "disable_for_touch:true" %>
        #
        def f_tooltip(text="", title="", position="bottom", options={})
          content_tag(:span, data: { tooltip: true, options: options[:options] }, class: "has-tip tip-#{position} #{options[:class]}", title: title, id: options[:id]) do
            text
          end
        end
      end
    end
  end
end
