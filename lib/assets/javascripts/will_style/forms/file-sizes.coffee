$(document).on "change", "[data-max-file-size]", (event) ->
  maxFileSize = $(event.currentTarget).data('max-file-size')

  $.each event.currentTarget.files, ->
    if @size and maxFileSize and @size > parseInt(maxFileSize)
      alert "This file exceeds the maximum allowed file size."
      $(event.currentTarget).val ''
      return
