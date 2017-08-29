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
      # Helpers for images
      #
      module ImageHelper

        # Simplifies creating an image interchange tag.
        #
        # = Params
        #
        # +source+
        #
        # The original source file for the image. Do not use any size information here.
        #
        # You can use any of the html options available in ActionView helpers.
        #
        # +interchange+
        #
        # Hash of interchange key values.
        #
        # Ex: { default: 20, large: 32 }
        #
        # +append+
        #
        # Whether to append the interchange values to the original filename or use them raw.
        #
        # Default: true
        #
        # +options+
        #
        # Hash of options.
        #
        # You can use any of the html options available for the image_tag
        #
        # = Examples
        #  Using filename replace (NOTE: will_logo.png doesn't exist here, the default is appended to the file):
        #    <%= image_interchange_tag "will-style/will_logo.png", { default: 20, medium: 32 }, class: "logo", title: "WILL" %>
        #
        #  Using raw filenames
        #    <%= image_interchange_tag "medium_image.png", { small: "small.jpg", medium: "medium_image.png", large: "big-guy.gif" }, true %>
        #
        def image_interchange_tag(source, interchange, append_filename=true, options={})
          default_size = nil

          chunks = source.split(".")
          extension = chunks.pop
          filename = chunks.join(".")

          unless interchange.has_key?(:default)
            if append_filename
              interchange[:default] = ""
            else
              interchange[:default] = source
            end
          end

          fixed_interchange = []
          interchange.each do |key, value|
            default_size = value if key == :default

            new_filename = "#{asset_path("#{value}")}"
            if append_filename
              if value == ""
                new_filename = "#{asset_path("#{filename}.#{extension}")}"
              else
                new_filename = "#{asset_path("#{filename}_#{value}.#{extension}")}"
              end
            end

            fixed_interchange << "[#{new_filename}, (#{key.to_s})]"
          end

          source = "#{filename}_#{default_size}.#{extension}" if default_size && append_filename

          options[:data] = {} unless options[:data]
          options[:data][:interchange] = fixed_interchange.join(", ")

          options[:data][:interchange]
          image_tag source, options
        end
      end
    end
  end
end
