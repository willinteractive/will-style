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
      # Helpers for generating our custom WILL page header
      #
      module PageHeaderHelper

        ##
        # Generates a page header component. Wrap this around your application content. This returns a page header builder you can use to build columns.
        #
        # = Params
        # +options+
        #
        # Any erb options for ordered lists.
        #
        # = Examples
        #   <%= ws_page_header do |p| %>
        #     <%= p.column class: "small-12" do %>
        #       <h1>Column information</h1>
        #     <% end %>
        #
        def ws_page_header(options={}, &block)
          raise ArgumentError, "Missing block" unless block_given?

          options[:class] = "app-page-header #{options[:class]}"
          content_tag(:header, options) do
            content_tag(:div, class: "row") do
              capture(PageHeaderBuilder.new(self), &block)
            end
          end
        end

        ##
        # Builder used to generate page header components.
        #
        class PageHeaderBuilder
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
          # Generates a column wrapper for content
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
          #   <%= p.column "small-10 medium-8" do %>
          #     <h1>This is content.</h1>
          #   <% end %>
          #
          def column(sizes="small-12", options={}, &block)
            raise ArgumentError, "Missing block" unless block_given?

            if sizes.is_a?(Hash)
              options = options.merge(sizes)
              sizes = ""
            end

            options[:class] = "columns #{sizes} #{options[:class]}"

            content_tag(:div, options) do
              capture(&block)
            end
          end
        end
      end
    end
  end
end
