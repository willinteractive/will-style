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
      # Helpers for generating our custom WILL hideable sidebar
      #
      module HideableSidebarHelper

        ##
        # Generates a hideable sidebar component. This returns a sidebar builder that you can use to generate the sidebar menu as well as buttons to trigger opening the sidebar.
        #
        # = Params
        # +options+
        #
        # Hash of options.
        #
        # You can use any of the html options available in ActionView helpers.
        # = Examples
        #   <%= ws_hideable_sidebar do |s| %>
        #     <%= s.menu do %>
        #       <h1>Menu</h1>
        #       <ul>
        #         <li>Home</li>
        #       </ul>
        #     <% end %>
        #
        #     <% s.content do %>
        #       <%= s.button "Open Menu" %>
        #       <p>Other Content</p>
        #     <% end %>
        #   <% end %>
        #
        def ws_hideable_sidebar(options={}, &block)
          raise ArgumentError, "Missing block" unless block_given?

          options[:class] = "off-canvas-wrap #{options[:class]}"
          
          # Merge custom html data options with mandatory alert data options
          if options[:data] && options[:data].is_a?(Hash)
            options[:data] = options[:data].merge({ offcanvas: true })
          else
            options[:data] = { offcanvas: true }
          end

          content_tag(:div, options) do
            capture(HideableSidebarBuilder.new(self), &block)
          end
        end

        ##
        # Builder used to generate hideable sidebar components.
        #
        class HideableSidebarBuilder
          ##
          # The parent template used to access ActionView Helper Methods
          #
          attr_accessor :template

          ##
          # Initialize the SidebarBuilder
          #
          def initialize(template)
            self.template = template
          end

          delegate :capture, :content_tag, :link_to, to: :template

          ##
          # Generates a hideable sidebar toggle button. You can either specify button text
          # or use an ERB Block to fill in HTML content.
          # = Params
          # +text+
          #
          # text you would like to display in the sidebar button.
          #
          # +options+
          #
          # Hash of options.
          #
          # You can use any of the html options available in ActionView helpers.
          #
          # +block+
          #
          # ERB Block for the sidebar button if it needs to be HTML content.
          #
          # = Examples
          # Default Functionality
          #   <%= h.button "Open the sidebar", class: "round" %>
          # With ERB Block
          #   <%= h.button do %>
          #     <h1>Open the sidebar</h1>
          #   <% end %>
          #
          def button(text="", options={}, &block)
            options = options.merge(text) if block_given? && text.is_a?(Hash)

            options[:class] = "left-off-canvas-toggle #{options[:class]}"

            if block_given?
              link_to("#", options) do
                capture(&block)
              end
            else
              link_to(text, "#", options)
            end
          end

          ##
          # Generates the hideable sidebar menu area.
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
          # ERB Block for the menu area.
          #
          # = Examples
          #   <%= h.menu do %>
          #     <h1>This is the menu area</h1>
          #   <% end %>
          #
          def menu(options={}, &block)
            raise ArgumentError, "Missing block" unless block_given?
  
            options[:class] = "hideable-sidebar #{options[:class]}"

            content_tag(:aside, options) do
              capture(&block)
            end
          end
        end
      end
    end
  end
end
