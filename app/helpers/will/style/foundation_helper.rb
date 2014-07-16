include WILL::Style::Foundation::AlertHelper

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

      ##
      # Generates a modal. This returns a modal builder that you can use to generate both the modal window and the trigger button.
      # = Params
      # +id+
      #
      # The id you would like to give the modal. Defaults to will-style-modal
      #
      # = Examples
      #   <%= f_modal "myModal" do |m| %>
      #     <%= m.trigger "Open my Modal" %>
      #
      #     <%= m.modal class="large" do %>
      #       <strong>My</strong> Modal content
      #     <% end %>
      #   <% end %>
      #
      def f_modal(id="will-style-modal", &block)
        raise ArgumentError, "Missing block" unless block_given?

        capture(ModalBuilder.new(id, self), &block)
      end

      ##
      # Builder used to generate modal components.
      #
      class ModalBuilder
        ##
        # The HTML id for the modal window
        #
        attr_accessor :id

        ##
        # The parent template used to access ActionView Helper Methods
        #
        attr_accessor :template

        ##
        # Initialize the ModalBuilder
        #
        def initialize(id, template)
          self.id = id
          self.template = template
        end

        delegate :capture, :content_tag, :link_to, to: :template

        ##
        # Generates a modal trigger. You can either specify button text
        # or use an ERB Block to fill in HTML content.
        # = Params
        # +text+
        #
        # text you would like to display in the trigger button.
        #
        # +options+
        #
        # Hash of options.
        #
        # :id – element id.
        #
        # :class – will add classes to the button.
        #
        # +block+
        #
        # ERB Block for the trigger button if it needs to be HTML content.
        #
        # = Examples
        # Default Functionality
        #   <%= m.trigger "Open the modal", class: "round" %>
        # With ERB Block
        #   <%= m.trigger do %>
        #     <h1>Open the modal</h1>
        #   <% end %>
        #
        def trigger(text="", options={}, &block)
          if block_given?
            options = options.merge(text) if text.is_a?(Hash)
            
            link_to("#", class: "button #{options[:class]}", id: options[:id], data: { "reveal-id" => @id }) do
              capture(&block)
            end
          else
            link_to(text, "#", class: "button #{options[:class]}", id: options[:id], data: { "reveal-id" => @id })
          end
        end

        ##
        # Generates the modal content.
        # = Params
        #
        # +options+
        #
        # Hash of options.
        #
        # :id – element id.
        #
        # :class – will add classes to the modal. 
        #
        # :dismissable - whether or not to include the close button. Defaults to true.
        #
        # +block+
        #
        # ERB Block for the modal.
        #
        # = Examples
        #   <%= m.modal class="large" do %>
        #     <strong>My</strong> Modal content
        #   <% end %>
        #
        def modal(options={}, &block)
          raise ArgumentError, "Missing block" unless block_given?

          content = capture(&block)

          can_dismiss = !options.has_key?(:dismissable) || options[:dismissable] == true

          content_tag(:div, data: { reveal: true }, class: "reveal-modal #{options[:class]}", id: @id, "data-options" => can_dismiss ? "" : "close_on_background_click:false") do
            if can_dismiss
              content + @template.link_to("&times;".html_safe, "#", class: "close-reveal-modal")
            else
              content              
            end
          end
        end
      end
    end
  end
end
