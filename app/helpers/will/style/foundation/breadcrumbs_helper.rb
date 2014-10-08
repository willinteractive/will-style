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
        # Generates a standalone breadcrumb item tag.
        #
        def f_breadcrumbs_item(text="", options={}, &block)
          item = nil

          f_breadcrumbs do |b|
            item = b.item(text, options, &block)
          end

          item
        end

        ##
        # Generates a standalone breadcrumb link tag.
        #
        def f_breadcrumbs_link(text="", target="#", options={}, &block)
          link = nil

          f_breadcrumbs do |b|
            link = b.link(text, target, options, &block)
          end

          link
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
          # +options+
          #
          # Hash of options.
          #
          # You can use any of the html options available in ActionView helpers, plus:
          #
          # +current+
          #
          # Whether or not this is the current element in the breadcrumbs
          #
          # +unavailable+
          #
          # If this element is unavailable
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
          def item(text="", options={}, &block)
            if block_given?
              content = capture(&block)
              options = options.merge(text) if text.is_a?(Hash)
            else
              content = text.html_safe
            end

            li_class = options[:current] == true ? "current" : ""
            li_class = "#{li_class} unavailable" if options[:unavailable] == true

            content_tag(:li, class: li_class) do
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
          # +options+
          #
          # Hash of options.
          #
          # You can use any of the html options available in ActionView helpers, plus:
          #
          # +current+
          #
          # Whether or not this is the current element in the breadcrumbs
          #
          # +unavailable+
          #
          # If this element is unavailable
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
          def link(text="", target="#", options={}, &block)
            if block_given?
              content = capture(&block)

              options = options.merge(target) if target.is_a?(Hash)
              target = text
            else
              content = text.html_safe
            end

            li_class = options[:current] == true ? "current" : ""
            li_class = "#{li_class} unavailable" if options[:unavailable] == true

            content_tag(:li, class: li_class) do
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
