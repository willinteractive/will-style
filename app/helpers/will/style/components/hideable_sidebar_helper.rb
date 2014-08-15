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
        # Generates a hideable sidebar component. Wrap this around your application content. This returns a sidebar builder that you can use to generate the sidebar menu as well as buttons to trigger opening the sidebar.
        #
        # To properly build a hideable sidebar, you should.
        #
        # 1] Use the container around your application content
        #
        # 2] Use h.wrapper around your h.sidebar and h.content.
        #
        # 3] Use h.button to build a trigger for the sidebar.
        #
        # = Examples
        #   <%= ws_hideable_sidebar_container do |h| %>
        #     <h1>Header information</h1>
        #
        #     <div id="main-content-area" class="row">
        #       <%= h.sidebar do %>
        #         <h1>Menu</h1>
        #         <ul>
        #           <li>Home</li>
        #         </ul>
        #       <% end %>
        #
        #       <main id="content"
        #         <%= s.button "Open Menu" %>
        #         <p>Other Content</p>
        #       </main>
        #     </div>
        #   <% end %>
        #
        def ws_hideable_sidebar_container(&block)
          raise ArgumentError, "Missing block" unless block_given?

          capture(HideableSidebarBuilder.new(self), &block)
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
          # Generates the wrapper to hold the sidebar and the main content area.
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
          # ERB Block for the wrapper.
          #
          # = Examples
          #   <%= h.wrapper do %>
          #     <%= h.sidebar do %>
          #       <h1>This is the menu area</h1>
          #     <% end %>
          #
          #     <%= h.content do %>
          #       <h1>This is the main content area</h1>
          #     <% end %>
          #   <% end %>
          #
          def wrapper(options={}, &block)
            raise ArgumentError, "Missing block" unless block_given?
  
            options[:class] = "off-canvas-wrap #{options[:class]}"

            # Merge custom html data options with mandatory alert data options
            if options[:data] && options[:data].is_a?(Hash)
              options[:data] = options[:data].merge({ offcanvas: true })
            else
              options[:data] = { offcanvas: true }
            end

            content_tag(:div, options) do
              content_tag(:div, class: "row collapse inner-wrap") do
                capture(&block)
              end
            end
          end

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

            if options[:data] && options[:data].is_a?(Hash)
              options[:data] = options[:data].merge({ "no-turbolinks" => true })
            else
              options[:data] = { "no-turbolinks" => true }
            end

            if block_given?
              link_to("#", options) do
                capture(&block)
              end
            else
              link_to(text, "#", options)
            end
          end

          ##
          # Generates the hideable sidebar.
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
          # ERB Block for the sidebar.
          #
          # = Examples
          #   <%= h.sidebar do %>
          #     <h1>This is the menu area</h1>
          #   <% end %>
          #
          def sidebar(options={}, &block)
            raise ArgumentError, "Missing block" unless block_given?
  
            options[:class] = "hideable-sidebar columns #{options[:class]}"

            content_tag(:aside, options) do
              capture(&block)
            end
          end

          ##
          # Generates the main content area.
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
          # ERB Block for the content area.
          #
          # = Examples
          #   <%= h.content do %>
          #     <h1>This is the main content area</h1>
          #   <% end %>
          #
          def content(options={}, &block)
            raise ArgumentError, "Missing block" unless block_given?
  
            options[:class] = "columns #{options[:class]}"

            content_tag(:main, options) do
              capture(&block)
            end
          end
        end
      end
    end
  end
end
