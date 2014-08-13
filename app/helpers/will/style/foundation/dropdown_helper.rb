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
      # Helpers for generating Foundation dropdowns
      #
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
          # :show_trigger - Set to false to hide the trigger arrow.
          #
          # +block+
          #
          # ERB Block for the trigger button if it needs to be HTML content.
          #
          # = Examples
          # Default Functionality
          #   <%= d.button "Open the dropdown", class: "round" %>
          # With ERB Block
          #   <%= d.button do %>
          #     <h1>Open the dropdown</h1>
          #   <% end %>
          #
          def button(text="", options={}, &block)
            options = options.merge(text) if block_given? && text.is_a?(Hash)

            # Merge custom html data options with mandatory alert data options
            data = { dropdown: @id }

            if options[:data] && options[:data].is_a?(Hash)
              options[:data] = options[:data].merge(data)
            else
              options[:data] = data
            end

            hide_trigger = options.has_key?(:show_trigger) && options[:show_trigger] == false
            options[:class] = "button#{ hide_trigger ? "" : " dropdown" } #{options[:class]}"

            if block_given?
              link_to("#", options) do
                capture(&block)
              end
            else
              link_to(text, "#", options)
            end
          end

           ##
          # Generates a dropdown trigger link. You can either specify link text
          # or use an ERB Block to fill in HTML content.
          # = Params
          # +text+
          #
          # text you would like to display in the trigger link.
          #
          # +options+
          #
          # Hash of options.
          #
          # You can use any of the html options available in ActionView helpers.
          #
          # :show_trigger - Set to false to hide the trigger arrow.
          #
          # +block+
          #
          # ERB Block for the trigger link if it needs to be HTML content.
          #
          # = Examples
          # Default Functionality
          #   <%= d.link "Open the dropdown"%>
          # With ERB Block
          #   <%= d.link do %>
          #     <h1>Open the dropdown</h1>
          #   <% end %>
          #
          def link(text="", options={}, &block)
            options = options.merge(text) if block_given? && text.is_a?(Hash)

            # Merge custom html data options with mandatory alert data options
            data = { dropdown: @id }

            if options[:data] && options[:data].is_a?(Hash)
              options[:data] = options[:data].merge(data)
            else
              options[:data] = data
            end

            hide_trigger = options.has_key?(:show_trigger) && options[:show_trigger] == false
            options[:class] = "#{ hide_trigger ? "" : " dropdown" } #{options[:class]}"

            if block_given?
              link_to("#", options) do
                capture(&block)
              end
            else
              link_to(text, "#", options)
            end
          end

          ##
          # Generates a dropdown trigger split button. You can either specify button text
          # or use an ERB Block to fill in HTML content.
          # = Params
          # +text+
          #
          # text you would like to display in the trigger button.
          #
          # +target+
          #
          # the target for the main button
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
          #   <%= d.button_split "Open the dropdown", class: "round" %>
          # With ERB Block
          #   <%= d.button_split do %>
          #     <h1>Open the dropdown</h1>
          #   <% end %>
          #
          def button_split(text="", target="", options={}, &block)
            if block_given?
              content = capture(&block)

              options = options.merge(target) if target.is_a?(Hash)
              target = text
            else
              content = text.html_safe
            end

            options[:class] = "button split #{options[:class]}"

            link_to(target, options) do
              content + content_tag(:span, "", data: { dropdown: @id })
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
              content = text.html_safe
            end

            content_tag(:li) do
              link_to(target, options) do
                content
              end
            end
          end

          ##
          # Sets up a dropdown divider
          #
          # = Examples
          #   <%= d.divider %>
          #
          def divider()
            content_tag(:li, "", class: "divider")
          end

          ##
          # Generates a dropdown content area.
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
          # ERB Block for the dropdown content.
          #
          # = Examples
          #   <%= d.content do %>
          #     <p>Dropdown Content</p>
          #   <% end %>
          #
          def content(options={}, &block)
            raise ArgumentError, "Missing block" unless block_given?

            # Merge custom html data options with mandatory modal data options
            data = { "dropdown-content" => true }

            if options[:data] && options[:data].is_a?(Hash)
              options[:data] = options[:data].merge(data)
            else
              options[:data] = data
            end

            options[:id] = @id
            options[:class] = "f-dropdown content #{options[:class]}"

            content_tag(:div, options) do
              capture(&block)
            end
          end
        end
      end
    end
  end
end
