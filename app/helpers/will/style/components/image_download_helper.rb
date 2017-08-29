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
      module ImageDownloadHelper

        # Creates an image tag with a download link next to it – can be set to download a png or svg version.
        #
        # = Params
        #
        # +source+
        #
        # The original source file for the image. Do not use any size information here.
        #
        # You can use any of the html options available in ActionView helpers.
        #
        # +formats+
        #
        # Array of extra download formats available. Will default to the source format.
        #
        # Ex: [ "png", "svg", "gif" ]
        #
        # Hash of options.
        #
        # You can use any of the html options available for the image_tag
        #
        # = Examples
        # <%= image_download_tag "logo.png", formats: [ "png", "svg" ] %>
        #
        def image_download_tag(source, formats=[], options={})
          chunks = source.split(".")

          extension = chunks.pop

          filename = chunks.join(".")

          formats.push(extension) unless formats.include?(extension)

          elements = [ image_tag(source, options) ]

          formats.each do |format|
            elements.push link_to(asset_url("#{filename}.#{format}"), class: "button image-download-button", target: :blank, downlaod: "image") { "<p>#{fa_icon("download")} #{format}</p>".html_safe }
          end

          # @TODO: Add download button
          # @TODO: Add multiple formats
          content_tag(:div, class: "image-download-container") do
            elements.join.html_safe
          end
        end
      end
    end
  end
end
