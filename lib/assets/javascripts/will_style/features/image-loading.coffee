#
# Set Loading and Loaded properties for images and image backgrounds
#

imageLoadingQuery = ".image-bg:not(.loaded), .image-bg-display:not(.loaded), img:not(.loaded)"

loadedImages = { }

imagePollInterval = undefined

# Get the source of an image or css background-image
getImageSourceForElement = (element) ->
  source = ""

  if element.is("img")
    unless element.attr("srcset")
      element.attr("src", element.attr("data-src")) if element.attr("data-src")?
      source = element.attr("src")
  else
    bg = element.css('background-image')

    if bg.indexOf("url") isnt -1
      matches = bg.match(/url\(.*?\)/gi)

      if matches and matches.length > 0
        source = matches[matches.length - 1].replace('url(','').replace(')','').replace(/[\"\']/gi, "")

  # Ensure source is empty string for logic checking
  source = "" unless source

  source

# Preset loading state if image has already been loaded
presetImageLoading = (images) ->
  $(images).each ->
    element = $(this)

    source = getImageSourceForElement(element)

    if element.hasClass("loaded") or loadedImages.hasOwnProperty(source)
      element.addClass("loaded")

# Setup loading / loaded statuses for all images
setUpImageLoading = ->
  $(imageLoadingQuery).each ->
    element = $(this)
    imageElement = false

    source = getImageSourceForElement(element)

    if element.hasClass("loaded") or loadedImages.hasOwnProperty(source)
      element.addClass("loaded")
      element.removeAttr("data-image-loading-checking")

    else if source is "" and not element.attr("data-src")?
      if element.attr("srcset")
        imageElement = element[0]
      else
        element.addClass("loaded")
        element.removeAttr("data-image-loading-checking")

    else if element.attr("data-image-loading-checking")?
      # Don't scan
    else
      element.attr("data-image-loading-checking", true)

      element.addClass("loading")
      imageElement = new Image()
      imageElement.src = source

    if imageElement
      if imageElement.complete
        element.removeClass("loading")
        element.addClass("loaded")
        element.removeAttr("data-image-loading-checking")
        window.WILLStyle.Events.trigger "image-loaded", element

      else
        imageElement.onload = ->
          loadedImages[source] = ""

          element.removeClass("loading")
          element.addClass("loaded")
          element.removeAttr("data-image-loading-checking")

          if not imageElement.complete or imageElement.naturalHeight is 0
            element.addClass("error")

          window.WILLStyle.Events.trigger "image-loaded", element

        imageElement.onerror = ->
          setTimeout ->
            element.removeClass("loading")
            element.addClass("loaded")
            element.addClass("error")
          , 1000

# Update image loading on turbo load
$(document).on window.WILLStyle.Settings.pageChangeEvent, ->
  # Delay checking image backgrounds to make sure we catch added via javascript
  setTimeout ->
    setUpImageLoading()
  , 1

# Pre-process image loading when we revisit pages in turbo
$(document).on 'turbo:before-render', (event) ->
  presetImageLoading($(event.originalEvent.detail.newBody).find(imageLoadingQuery))

# Set up image poll interval to automatically check for images
imagePollInterval = setInterval ->
  setUpImageLoading()
, 500
