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
      # Helpers for generating Foundation dropdowns
      module DropdownHelper

        ##
        # Generates a dropdown. This returns a dropdown builder that you can use to generate both the dropdown list and the dropdown button or trigger.
        # = Params
        # +id+
        #
        # The id you would like to give the dropdown. Defaults to will-style-dropdown
        #
        # = Examples
        #   <%= f_dropdown "drop" do |d| %>
        #     <%= d.button "Dropdown Button" %>
        #
        #     <%= d.list do %>
        #       <%= d.item "This is a link" %>
        #       <%= d.item "This is another" %>
        #       <%= d.item "This is yet another" %>
        #     <% end %>
        #   <% end %>
        #
        def f_dropdown(id="will-style-dropdown", &block)
          raise ArgumentError, "Missing block" unless block_given?

          capture(DropdownBuilder.new(id, self), &block)
        end

        ##
        # Builder used to generate dropdown components.
        #
        class DropdownBuilder
          ##
          # The HTML id for the dropdown list
          #
          attr_accessor :id

          ##
          # The parent template used to access ActionView Helper Methods
          #
          attr_accessor :template

          ##
          # Initialize the DropdownBuilder
          #
          def initialize(id, template)
            self.id = id
            self.template = template
          end

          delegate :capture, :content_tag, :link_to, to: :template

          ##
          # Generates a dropdown trigger button. You can either specify button text
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
          # You can use any of the html options available in ActionView helpers.
          #
          # +block+
          #
          # ERB Block for the trigger button if it needs to be HTML content.
          #
          # = Examples
          # Default Functionality
          #   <%= d.button "Open the dropdown", class: "round" %>
          # With ERB Block
          #   <%= d.dropdown do %>
          #     <h1>Open the dropdown</h1>
          #   <% end %>
          #
          def button(text="", options={}, &block)
            options = options.merge(text) if text.is_a?(Hash) if block_given?

            # Merge custom html data options with mandatory alert data options
            data = { dropdown: @id }

            if options[:data] && options[:data].is_a?(Hash)
              options[:data] = options[:data].merge(data)
            else
              options[:data] = data
            end

            options[:class] = "button dropdown #{options[:class]}"

            if block_given?
              link_to("#", options) do
                capture(&block)
              end
            else
              link_to(text, "#", options)
            end
          end

          ##
          # Generates a dropdown trigger span you can attach to a button.
          # = Params
          #
          # +options+
          #
          # Hash of options.
          #
          # You can use any of the html options available in ActionView helpers.
          # = Examples
          #   <%= d.trigger %>
          #
          def trigger(options={})
            # Merge custom html data options with mandatory dropdown trigger options
            data = { dropdown: @id }

            if options[:data] && options[:data].is_a?(Hash)
              options[:data] = options[:data].merge(data)
            else
              options[:data] = data
            end

            content_tag(:span, "", options)
          end

          ##
          # Generates the dropdown list.
          # = Params
          #
          # +options+
          #
          # Hash of options.
          #
          # You can use any of the html options available in ActionView helpers.
          #
          # +block+
          #
          # ERB Block for the dropdown list.
          #
          # = Examples
          #   <%= d.list class="large" do %>
          #     <%= d.item "This is a link" %>
          #   <% end %>
          #
          def list(options={}, &block)
            raise ArgumentError, "Missing block" unless block_given?

            # Merge custom html data options with mandatory modal data options
            data = { "dropdown-content" => true }

            if options[:data] && options[:data].is_a?(Hash)
              options[:data] = options[:data].merge(data)
            else
              options[:data] = data
            end

            options[:id] = @id
            options[:class] = "f-dropdown #{options[:class]}"

            content_tag(:ul, options) do
              capture(&block)
            end
          end

          ##
          # Generates a dropdown list item. You can either specify button text
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
          # ERB Block for the dropdown item if it needs to be HTML Content.
          #
          # = Examples
          #   <%= d.item "http://google.com" do %>
          #     <strong>Perform</strong> a search
          #   <% end %>
          #
          def item(text="", target="#", options={}, &block)
            if block_given?
              content = capture(&block)

              options = options.merge(target) if target.is_a?(Hash)
              target = text
            else
              content = content_tag(:span, text)
            end

            content_tag(:li) do
              link_to("#", options) do
                content
              end
            end
          end
        end
      end
    end
  end
end
