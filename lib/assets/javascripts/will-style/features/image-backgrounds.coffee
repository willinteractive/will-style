#------------------------------------------------------------------------------------------
# This class will transform images with a data-image-bg to add it using a DOM element     -
#------------------------------------------------------------------------------------------

$(document).on 'turbolinks:load', (event) ->
  $("[data-image-bg]").each ->
    $(this).prepend("<div class=\"image-bg-display\" style=\"background-image: url('#{$(this).attr("data-image-bg")}')\"></div>")
