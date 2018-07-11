#
# Set Loading and Loaded properties for images and image backgrounds
#

imageLoadingQuery = ".image-bg, .image-bg-display, img"

loadedImages = { }

# Get the source of an image or css background-image
getImageSourceForElement = (element) ->
    source = ""

    if element.is("img")
      source = element.attr("src")
    else
      bg = element.css('background-image')

      if bg.indexOf("url") is 0
        source = bg.replace('url(','').replace(')','').replace(/\"/gi, "")

    # Ensure source is empty string for logic checking
    source = "" unless source

    source

# Preset loading state if image has already been loaded
presetImageLoading = (images) ->
  $(images).each ->
    element = $(this)

    source = getImageSourceForElement(element)

    if element.hasClass("loaded") or source is "" or loadedImages.hasOwnProperty(source)
      element.addClass("loaded")

# Setup loading / loaded statuses for all images
setUpImageLoading = ->
  $(imageLoadingQuery).each ->
    element = $(this)

    source = getImageSourceForElement(element)

    if element.hasClass("loaded") or source is "" or loadedImages.hasOwnProperty(source)
      element.addClass("loaded")
    else
      element.addClass("loading")

      img = new Image()

      img.onload = ->
        loadedImages[source] = ""

        element.removeClass("loading")
        element.addClass("loaded")

        if not img.complete or img.naturalHeight is 0
          element.addClass("error")

      img.onerror = ->
        setTimeout ->
          element.removeClass("loading")
          element.addClass("loaded")
          element.addClass("error")
        , 1000

      img.src = source

# Update image loading on turbolinks load
$(document).on window.WILLStyleSettings.pageChangeEvent, ->
  # Delay checking image backgrounds to make sure we catch added via javascript
  setTimeout ->
    setUpImageLoading()
  , 1

# Pre-process image loading when we revisit pages in turbolinks
$(document).on 'turbolinks:before-render', (event) ->
  presetImageLoading($(event.originalEvent.data.newBody).find(imageLoadingQuery))
