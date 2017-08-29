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
      # Helpers for generating our custom WILL Style Search Bar
      #
      module FancySearchHelper

        ##
        # Generates a search bar. This returns a search builder that you can use to fill in a custom options menu if you want.
        # The search bar and button are generated for you automatically.
        #
        # = Params
        #
        # +path+
        #
        # The search path for the search form.
        #
        # +query (optional)+
        #
        # The existing search query for the search form
        #
        # +placeholder+
        #
        # Placeholder text for an empty search field
        #
        # default: Search...
        #
        # +options+
        #
        # Hash of options.
        #
        # You can use any of the html options available in ActionView helpers.
        #
        # = Examples
        # Default Functionality
        #   <%= ws_fancy_search %>
        # With ERB Block
        #   <%= ws_fancy_search do |s| %>
        #     <%= s.input "Search in products" %>
        #     <%= s.button %>
        #   <% end %>
        #
        def ws_fancy_search(path="", query="", placeholder="Search...", options={}, &block)
          # Make query and placeholder completely optional
          options = placeholder if placeholder.is_a?(Hash)
          options = query if query.is_a?(Hash)

          # Set up mandatory options
          options[:class] = "search-form #{options[:class]}"
          options[:action] = "search"
          options[:method] = :get
          options[:enforce_utf8] = false

          autofocus = options[:autofocus] == true
          options.delete(:autofocus) if options[:autofocus]

          form_tag(path, options) do
            builder = FancySearchBuilder.new(self, query, autofocus)
            block_content = block_given? ? capture(builder, &block) : ""

            content_tag(:div, class: "row collapse") do
              [
                block_content,
                builder.input(placeholder),
                builder.button,
                utf8_enforcer_tag
              ].join.html_safe
            end
          end
        end

        ##
        # Builder used to generate dropdown components.
        #
        class FancySearchBuilder
          ##
          # The parent template used to access ActionView Helper Methods
          #
          attr_accessor :template

          ##
          # The existing query string from the form
          #
          attr_accessor :q

          ##
          # Whether or not to autofocus search input
          #
          attr_accessor :autofocus

          ##
          # Whether or not we've built an options menu
          #
          attr_accessor :built_options_menu

          ##
          # Initialize the SearchBuilder
          #
          def initialize(template, q, autofocus=false)
            self.template = template
            self.q = q
            self.autofocus = autofocus

            self.built_options_menu = false
          end

          delegate :capture, :content_tag, :link_to, :fa_icon, :text_field_tag, :submit_tag, to: :template

          ##
          # Generates the search button.
          #
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
          # ERB Block for the sidebar button if it needs to be HTML content.
          #
          # = Examples
          #   <%= s.button %>
          #
          def button(options={})
            options[:class] = "button search-button secondary postfix #{options[:class]}"
            options[:type] = "submit"

            if options[:data] && options[:data].is_a?(Hash)
              options[:data] = options[:data].merge({ "no-turbolinks" => true })
            else
              options[:data] = { "no-turbolinks" => true }
            end

            content_tag(:div, class: "small-2 columns") do
              [
                link_to("#", options) do
                  [
                    fa_icon("search", class: "text-primary"),
                    content_tag(:span, class: "hide") do
                      "Search"
                    end
                  ].join.html_safe
                end,

                submit_tag("Submit Search", class: "hide")
              ].join.html_safe
            end
          end

          ##
          # Generates a search options menu. Returns a dropdown builder to build the menu.
          #
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
          #   <%= s.option_menu do |d| %>
          #     <%= d.item "This is a link" %>
          #   <% end %>
          #
          def option_menu(id="search-options", options={}, &block)
            raise ArgumentError, "Missing block" unless block_given?

            self.built_options_menu = true

            # Set up mandatory button options
            options[:class] = "button secondary prefix #{options[:class]}"
            options[:show_trigger] = false

            d = DropdownBuilder.new(id, template)

            # Build dropdown button and menu list
            [
              content_tag(:div, class: "small-2 columns") do
                d.button(options) do
                  fa_icon "cog"
                end
              end,

              d.list do
                capture(d, &block)
              end
            ].join.html_safe
          end

          ##
          # Generates the search input
          # = Params
          #
          # +placeholder+
          #
          # Placeholder text for an empty search field
          #
          # default: Search...
          #
          # +options+
          #
          # Hash of options.
          #
          # You can use any of the html options available in ActionView helpers.
          #
          # = Examples
          #   <%= s.input "Search here..." %>
          #
          def input(placeholder="Search...", options={})
            # Set up mandatory options
            options[:placeholder] = placeholder
            options[:type] = "search"
            options[:autocomplete] = "off"
            options[:autofocus] = autofocus

            content_tag(:div, class: "small-#{self.built_options_menu ? "8" : "10"} columns") do
              text_field_tag(:q, q, options)
            end
          end
        end
      end
    end
  end
end