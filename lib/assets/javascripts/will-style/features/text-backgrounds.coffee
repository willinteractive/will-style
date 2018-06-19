shuffle = (array) ->
  console.log 'x: '  + array
  i = array.length - 1

  while i > 0
    j = Math.floor(Math.random() * (i + 1))
    temp = array[i]
    array[i] = array[j]
    array[j] = temp
    i--


generateBGDomElement = (quote)->
  "<h1 class=\"quote-display text-light lead\" >#{quote}</h1>"


#------------------------------------------------------------------------------------------
# Transform images with a data-image-bg to add it using a DOM element                     -
#------------------------------------------------------------------------------------------

# $(document).on 'turbolinks:load', (event) ->
#   $("[data-quote-rotate]").each ->
#     $(this).prepend(generateBGDomElement($(this).attr("data-quote-rotate")))

# #------------------------------------------------------------------------------------------
# Rotating image backgrounds                                                              -
#------------------------------------------------------------------------------------------

rotationIntervals = []

$(document).on 'turbolinks:load', (event) ->
  console.log 'hereeeee'
  for interval in rotationIntervals
    clearInterval(interval)

  rotationIntervals = []
  allQuotes = []

  $("[data-quote-rotate]").each ->
      try
        allQuotes.push $(this).attr('data-quote-rotate')#.replace(/'/gi, '"')

      catch
        # JSON Parse error


  console.log '===> ' + allQuotes

  if allQuotes.length > 0
    #if $(this).attr("data-quote-rotate-randomize") is "" or $(this).attr("data-quote-rotate-randomize") is "true"
    shuffle(allQuotes)
    # if $(this).attr("data-quote-rotate-fixed") is "" or $(this).attr("data-quote-rotate-fixed") is "true"
    #   $(this).addClass("fixed")

    #$(this).addClass("quote-rotate")

    for q in allQuotes
      console.log 'new q: ' + q
      $("[data-quotes-holder]").append(generateBGDomElement(q))


    $($(this).find(".quote-display")[0]).addClass("active")#.addClass("first")

    quoteContainer = $(this)
    interval = setInterval ->
      quotes = quoteContainer.find(".quote-display")

      activeIndex = quoteContainer.find(".quote-display.active").index() + 1
      activeIndex = 0 if activeIndex > quotes.length - 1

      quotes.removeClass("active").removeClass("first")
      $(quotes[activeIndex]).addClass("active")
    , 15000

    rotationIntervals.push interval
