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
      # Helpers for generating Foundation modals
      #
      module ModalHelper

        ##
        # Generates a modal. This returns a modal builder that you can use to generate both the modal window and the trigger button.
        # = Params
        # +id+
        #
        # The id you would like to give the modal. Defaults to will-style-modal
        #
        # = Examples
        #   <%= f_modal "myModal" do |m| %>
        #     <%= m.trigger "Open my Modal" %>
        #
        #     <%= m.modal class="large" do %>
        #       <strong>My</strong> Modal content
        #     <% end %>
        #   <% end %>
        #
        def f_modal(id="will-style-modal", &block)
          raise ArgumentError, "Missing block" unless block_given?

          capture(ModalBuilder.new(id, self), &block)
        end

        ##
        # Builder used to generate modal components.
        #
        class ModalBuilder
          ##
          # The HTML id for the modal window
          #
          attr_accessor :id

          ##
          # The parent template used to access ActionView Helper Methods
          #
          attr_accessor :template

          ##
          # Initialize the ModalBuilder
          #
          def initialize(id, template)
            self.id = id
            self.template = template
          end

          delegate :capture, :content_tag, :link_to, to: :template

          ##
          # Generates a modal trigger. You can either specify button text
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
          #   <%= m.trigger "Open the modal", class: "round" %>
          # With ERB Block
          #   <%= m.trigger do %>
          #     <h1>Open the modal</h1>
          #   <% end %>
          #
          def trigger(text="", options={}, &block)
            options = options.merge(text) if text.is_a?(Hash) if block_given?

            # Merge custom html data options with mandatory alert data options
            if options[:data] && options[:data].is_a?(Hash)
              options[:data] = options[:data].merge({ "reveal-id" => @id })
            else
              options[:data] = { "reveal-id" => @id }
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
          # Generates the modal content.
          # = Params
          #
          # +options+
          #
          # Hash of options.
          #
          # You can use any of the html options available in ActionView helpers.
          #
          # :dismissable - whether or not to include the close button. Defaults to true.
          #
          # +block+
          #
          # ERB Block for the modal.
          #
          # = Examples
          #   <%= m.modal class="large" do %>
          #     <strong>My</strong> Modal content
          #   <% end %>
          #
          def modal(options={}, &block)
            raise ArgumentError, "Missing block" unless block_given?

            content = capture(&block)

            can_dismiss = !options.has_key?(:dismissable) || options[:dismissable] == true

            # Merge custom html data options with mandatory modal data options

            data_options = { reveal: true,
                             "options" => can_dismiss ? "" : "close_on_background_click:false;" }

            if options[:data] && options[:data].is_a?(Hash)
              options[:data] = options[:data].merge(data_options)
            else
              options[:data] = data_options
            end

            options[:id] = @id
            options[:class] = "reveal-modal #{options[:class]}"

            content_tag(:div, options) do
              if can_dismiss
                content + link_to("&times;".html_safe, "#", class: "close-reveal-modal")
              else
                content
              end
            end
          end

          ##
          # Generates a custom modal close button. You can either specify button text
          # or use an ERB Block to fill in HTML content.
          # = Params
          #
          # +text+
          #
          # text you would like to display in the close button.
          #
          # +type+
          #
          # Type of button. 
          #
          # <i>Possible values</i>: success, warning, info, alert, secondary. 
          #
          # <i>Default value</i>: warning.
          #
          # +options+
          #
          # Hash of options.
          #
          # You can use any of the html options available in ActionView helpers.
          #
          # +block+
          #
          # ERB Block for the close button if it needs to be HTML Content.
          #
          # = Examples
          #   <%= m.close_button do %>
          #     <strong>Close</strong> this modal
          #   <% end %>
          #
          def close_button(text="", type="warning", options={}, &block)
            options = options.merge(type) if type.is_a?(Hash) if block_given?

            options[:class] = "button #{type} reveal-close #{options[:class]}"

            if block_given?
              link_to("#", options) do
                capture(&block)
              end
            else
              link_to(text, "#", options)
            end
          end
        end
      end
    end
  end
end
