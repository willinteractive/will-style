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
    module Components

      ##
      # Helpers for generating our custom WILL Style sidebar
      module SidebarHelper

        ##
        # Generates a sidebar. This returns a sidebar builder that you can use to generate the sidebar menu as well as buttons to trigger opening the sidebar.
        #
        # = Examples
        #   <%= ws_sidebar do |s| %>
        #     <%= s.menu do %>
        #       <h1>Menu</h1>
        #       <ul>
        #         <li>Home</li>
        #       </ul>
        #     <% end %>
        #
        #    <% s.content do %>
        #      <%= d.button "Open Menu" %>
        #      <p>Other Content</p>
        #   <% end %>
        #
        def ws_sidebar(&block)
          raise ArgumentError, "Missing block" unless block_given?

          content_tag(:div, class: "sidebar-container") do
            capture(SidebarBuilder.new(self), &block)
          end
        end

        ##
        # Builder used to generate dropdown components.
        #
        class SidebarBuilder
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
          # Generates a sidebar open button. You can either specify button text
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
          #   <%= s.button "Open the sidebar", class: "round" %>
          # With ERB Block
          #   <%= s.button do %>
          #     <h1>Open the sidebar</h1>
          #   <% end %>
          #
          def button(text="", options={}, &block)
            options = options.merge(text) if block_given? && text.is_a?(Hash)

            options[:class] = "sidebar-button #{options[:class]}"

            if block_given?
              link_to("#", options) do
                capture(&block)
              end
            else
              link_to(text, "#", options)
            end
          end

          ##
          # Generates the sidebar menu area.
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
          #   <%= s.menu do %>
          #     <h1>This is the menu area</h1>
          #   <% end %>
          #
          def menu(options={}, &block)
            raise ArgumentError, "Missing block" unless block_given?
  
            options[:class] = "sidebar-menu #{options[:class]}"

            content_tag(:nav, options) do
              capture(&block)
            end
          end

          ##
          # Generates the main sidebar content area
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
          # ERB Block for the sidebar content.
          #
          # = Examples
          #   <%= s.content do %>
          #     <p>Sidebar Content</p>
          #   <% end %>
          #
          def content(options={}, &block)
            raise ArgumentError, "Missing block" unless block_given?

            options[:class] = "sidebar-content #{options[:class]}"

            content_tag(:div, class: "sidebar-pusher") do
              content_tag(:div, options) do
                capture(&block)
              end
            end
          end
        end
      end
    end
  end
end
