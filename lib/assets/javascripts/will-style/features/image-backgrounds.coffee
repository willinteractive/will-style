shuffle = (array) ->
  i = array.length - 1

  while i > 0
    j = Math.floor(Math.random() * (i + 1))
    temp = array[i]
    array[i] = array[j]
    array[j] = temp
    i--

generateBGDomElement = (image)->
  "<div class=\"image-bg-display\" style=\"background-image: url('#{image}')\"></div>"
#------------------------------------------------------------------------------------------
# Transform images with a data-image-bg to add it using a DOM element                     -
#------------------------------------------------------------------------------------------

$(document).on 'turbolinks:load', (event) ->
  $("[data-image-bg]").each ->
    $(this).prepend(generateBGDomElement($(this).attr("data-image-bg")))

#------------------------------------------------------------------------------------------
# Rotating image backgrounds                                                              -
#------------------------------------------------------------------------------------------

rotationIntervals = []

$(document).on 'turbolinks:load', (event) ->
  for interval in rotationIntervals
    clearInterval(interval)

  rotationIntervals = []

  $("[data-image-bgs]").each ->
    try
      bgs = JSON.parse $(this).attr("data-image-bgs").replace(/'/gi, '"')

      if bgs.length > 0
        if $(this).attr("data-image-bgs-randomize") is "" or $(this).attr("data-image-bgs-randomize") is "true"
          shuffle(bgs)

        if $(this).attr("data-image-bgs-fixed") is "" or $(this).attr("data-image-bgs-fixed") is "true"
          $(this).addClass("fixed")

        $(this).addClass("image-bgs")

        for bg in bgs
          $(this).append(generateBGDomElement(bg))

        $($(this).find(".image-bg-display")[0]).addClass("active").addClass("first")

        imageContainer = $(this)
        interval = setInterval ->
          bgs = imageContainer.find(".image-bg-display")

          activeIndex = imageContainer.find(".image-bg-display.active").index() + 1
          activeIndex = 0 if activeIndex > bgs.length - 1

          bgs.removeClass("active").removeClass("first")
          $(bgs[activeIndex]).addClass("active")
        , 15000

        rotationIntervals.push interval
    catch
      # JSON Parse error
