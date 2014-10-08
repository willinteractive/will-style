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
      # Helpers for generating Foundation Breadcrumbs
      #
      module BreadcrumbsHelper

        ##
        # Generates breadcrumbs. This returns a breadcrumbs builder that you can use to generate items.
        # = Params
        # +options+
        #
        # Any erb options for ordered lists.
        #
        # = Examples
        #   <%= f_breadcrumbs do |b| %>
        #     <%= b.item "item" %>
        #     <%= b.item "Another Item", active: true %>
        #
        def f_breadcrumbs(options={}, &block)
          raise ArgumentError, "Missing block" unless block_given?

          options[:class] = "breadcrumbs #{options[:class]}"
          content_tag(:ol, options) do
            capture(BreadcrumbsBuilder.new(self), &block)
          end
        end

        ##
        # Builder used to generate breadcrumb components.
        #
        class BreadcrumbsBuilder
          ##
          # The parent template used to access ActionView Helper Methods
          #
          attr_accessor :template

          ##
          # Initialize the BreadcrumbsBuilder
          #
          def initialize(template)
            self.template = template
          end

          delegate :capture, :content_tag, :link_to, to: :template

          ##
          # Generates a breadcrumbs item. You can either specify text
          # or use an ERB Block to fill in HTML content.
          # = Params
          #
          # +text+
          #
          # text you would like to display in the breadcrumbs item.
          #
          # +current+
          #
          # Whether or not this is the current element in the breadcrumbs
          #
          # +options+
          #
          # Hash of options.
          #
          # You can use any of the html options available in ActionView helpers.
          #
          # +block+
          #
          # ERB Block for the breadcrumbs item if it needs to be HTML Content.
          #
          # = Examples
          #   <%= b.item "http://google.com" do %>
          #     <strong>Perform</strong> a search
          #   <% end %>
          #
          def item(text="", current=false, options={}, &block)
            if current.is_a?(Hash)
              options = options.merge(current)
              current = false
            end

            if block_given?
              content = capture(&block)
              options = options.merge(text) if text.is_a?(Hash)
            else
              content = text.html_safe
            end

            content_tag(:li, class: current ? "current" : "") do
              content
            end
          end

          ##
          # Generates a breadcrumbs link. You can either specify text
          # or use an ERB Block to fill in HTML content.
          # = Params
          #
          # +text+
          #
          # text you would like to display in the breadcrumbs link.
          #
          # +target+
          #
          # Destination for clicking on the link. 
          #
          # +current+
          #
          # Whether or not this is the current element in the breadcrumbs
          #
          # +options+
          #
          # Hash of options.
          #
          # You can use any of the html options available in ActionView helpers.
          #
          # +block+
          #
          # ERB Block for the breadcrumbs link if it needs to be HTML Content.
          #
          # = Examples
          #   <%= b.link "http://google.com" do %>
          #     <strong>Perform</strong> a search
          #   <% end %>
          #
          def link(text="", target="#", current=false, options={}, &block)
            if current.is_a?(Hash)
              options = options.merge(current)
              current = false
            end

            if block_given?
              content = capture(&block)

              options = options.merge(target) if target.is_a?(Hash)
              target = text
            else
              content = text.html_safe
            end

            content_tag(:li, class: current ? "current" : "") do
              link_to(target, options) do
                content
              end
            end
          end
        end
      end
    end
  end
end
