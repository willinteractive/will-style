shuffle = (array) ->
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


$(document).on "click", "[data-testimonial-element]", (event) ->

  # @NOTE: This won't work if there are multiple testomonial blocks on the page
  for interval in rotationIntervals
    clearInterval interval



$(document).on 'turbolinks:load', (event) ->
  for interval in rotationIntervals
    clearInterval(interval)

  allQuotes = []

  $("[data-testimonial-quote]").each ->
      try

        allQuotes = $(this).attr("data-testimonial-quote").split(';');
        #allQuotes = JSON.parse $(this).attr("data-testimonial-quote")
        #.push $(this).attr('data-testimonial-quote')#.replace(/'/gi, '"')

        if allQuotes.length > 0 #Object.keys(allQuotes).length

          if $(this).attr("data-quote-randomize") is "" or $(this).attr("data-quote-randomize") is "true"
            shuffle(allQuotes)
          if $(this).attr("data-quote-fixed") is "" or $(this).attr("data-quote-fixed") is "true"
            $(this).addClass("fixed")

          #$(this).addClass("quote-rotate")
          for q in allQuotes
            $("[data-quotes-holder]").append(generateBGDomElement(q))

          $( $("[data-quotes-holder]").find(".quote-display")[0]).addClass("active")#.addClass("first")

          quoteContainer = $("[data-quotes-holder]")

          # if $("[data-quote-origin]").attr("data-quote-randomize") is "" or $("[data-quote-origin]").attr("data-quote-randomize") is "true"

          interval = setInterval ->
            quotes = quoteContainer.find(".quote-display")

            activeIndex = quoteContainer.find(".quote-display.active").index() + 1
            activeIndex = 0 if activeIndex > quotes.length - 1

            quotes.removeClass("active")#.removeClass("first")
            $(quotes[activeIndex]).addClass("active")
          , 1000

          rotationIntervals.push interval
