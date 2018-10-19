##
# Namespace module.
#
module WILL

  ##
  # Namespace module.
  #
  module Style

    ##
    # Helpers for generating WILL Style components
    #
    module Components

      ##
      # Helpers for generating our custom WILL List Group
      #
      module ListGroupHelper

        ##
        # Generates a list group. This returns a list group builder that you can use to fill in elements.
        #
        # = Params
        #
        # +options+
        #
        # Hash of options.
        #
        # You can use any of the html options available in ActionView helpers.
        #
        # = Examples
        #   <%= ws_list_group class: "radius" do |l| %>
        #     <%= l.item "Something" %>
        #   <% end %>
        #
        def ws_list_group(options={}, &block)
          # Set up mandatory options
          options[:class] = "list-group #{options[:class]}"

          content_tag(:ul, options) do
            capture(ListGroupBuilder.new(self), &block)
          end
        end

        ##
        # Builder used to generate list group components.
        #
        class ListGroupBuilder
          ##
          # The parent template used to access ActionView Helper Methods
          #
          attr_accessor :template

          ##
          # Initialize the ListGroupBuilder
          #
          def initialize(template)
            self.template = template
          end

          delegate :capture, :content_tag, :link_to, to: :template

          ##
          # Generates a list group item. You can either specify item text
          # or use an ERB Block to fill in HTML content.
          # = Params
          #
          # +text+
          #
          # text you would like to display in the list group item.
          #
          # +options+
          #
          # Hash of options.
          #
          # You can use any of the html options available in ActionView helpers.
          #
          # +block+
          #
          # ERB Block for the list group item if it needs to be HTML Content.
          #
          # = Examples
          #   <%= l.item do %>
          #     <strong>Perform</strong> a search
          #   <% end %>
          #
          def item(text="", options={}, &block)
            if block_given?
              content = capture(&block)
              options = options.merge(text) if text.is_a?(Hash)
            else
              content = text.html_safe
            end

            options[:class] = "list-group-item d-flex justify-content-between align-items-center #{options[:class]}"

            content_tag(:li, options) do
              content
            end
          end

          ##
          # Generates a list group link item. You can either specify link text
          # or use an ERB Block to fill in HTML content.
          # = Params
          #
          # +text+
          #
          # text you would like to display in the list item.
          #
          # +target+
          #
          # Destination for clicking on the item.
          #
          # +options+
          #
          # Hash of options.
          #
          # You can use any of the html options available in ActionView helpers.
          #
          # +block+
          #
          # ERB Block for the link item if it needs to be HTML Content.
          #
          # = Examples
          #   <%= l.link "http://google.com" do %>
          #     <strong>Perform</strong> a search
          #   <% end %>
          #
          def link(text="", target="", options={}, &block)
            if block_given?
              content = capture(&block)

              options = options.merge(target) if target.is_a?(Hash)
              target = text
            else
              content = text.html_safe
            end

            options[:class] = "list-group-item d-flex justify-content-between align-items-center #{options[:class]}"

            link_to(target, options) do
              content
            end
          end
        end
      end
    end
  end
end
