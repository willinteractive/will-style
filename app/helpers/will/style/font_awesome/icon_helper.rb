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
    module FontAwesome

      ##
      # Helpers for generating Font Awesome icons
      #
      module IconHelper

        # Creates an icon tag given an icon name and possible icon
        # modifiers.
        #
        # Examples
        #
        #   will_fa_icon "camera-retro"
        #   # => <span class="fa fa-camera-retro"></span>
        #
        #   will_fa_icon "camera-retro", text: "Take a photo"
        #   # => <span class="fa fa-camera-retro"></span> Take a photo
        #   will_fa_icon "chevron-right", text: "Get started", right: true
        #   # => Get started <span class="fa fa-chevron-right"></span>
        #
        #   will_fa_icon "camera-retro 2x"
        #   # => <span class="fa fa-camera-retro fa-2x"></span>
        #   will_fa_icon ["camera-retro", "4x"]
        #   # => <span class="fa fa-camera-retro fa-4x"></span>
        #   will_fa_icon "spinner spin lg"
        #   # => <span class="fa fa-spinner fa-spin fa-lg">
        #
        #   will_fa_icon "quote-left 4x", class: "pull-left"
        #   # => <span class="fa fa-quote-left fa-4x pull-left"></span>
        #
        #   will_fa_icon "user", data: { id: 123 }
        #   # => <span class="fa fa-user" data-id="123"></span>
        #
        #   content_tag(:li, will_fa_icon("check li", text: "Bulleted list item"))
        #   # => <li><span class="fa fa-check fa-li"></span> Bulleted list item</li>
        def will_fa_icon(names = "flag", options = {})
          classes = ["fa"]
          classes.concat Private.icon_names(names)
          classes.concat Array(options.delete(:class))
          text = options.delete(:text)
          right_icon = options.delete(:right)
          icon = content_tag(:span, nil, options.merge(class: classes))

          Private.icon_join(icon, text, right_icon)
        end
      end

      module Private
        extend ActionView::Helpers::OutputSafetyHelper

        def self.icon_join(icon, text, reverse_order = false)
          return icon if text.blank?
          elements = [icon, ERB::Util.html_escape(text)]
          elements.reverse! if reverse_order
          safe_join(elements, " ")
        end

        def self.icon_names(names = [])
          array_value(names).map { |n| "fa-#{n}" }
        end

        def self.array_value(value = [])
          value.is_a?(Array) ? value : value.to_s.split(/\s+/)
        end
      end
    end
  end
end
