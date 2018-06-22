shuffle = (quoteArrays, idArrays) ->
  i = quoteArrays.length - 1

  while i > 0
    j = Math.floor(Math.random() * (i + 1))

    # Shuffle Quotes
    temp = quoteArrays[i]
    quoteArrays[i] = quoteArrays[j]
    quoteArrays[j] = temp

    # Shuffle IDS
    temp2 = idArrays[i]
    idArrays[i] = idArrays[j]
    idArrays[j] = temp2

    i--


generateBGDomElement = (quote, index)->
  console.log 'index?? ' + index
  "<h1 id=#{index} class=\"quote-display text-light lead\" >#{quote}</h1>"


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

  quoteContainer = $("[data-quotes-holder]")
  quotes = quoteContainer.find(".quote-display")
  quotes.removeClass("active")

  currentCompany = $(this).attr('data-testimonial-element');

  $("[data-quotes-holder]").find("h1##{currentCompany}").addClass('active')

$(document).on 'turbolinks:load', (event) ->
  for interval in rotationIntervals
    clearInterval(interval)

  allQuotes = []


  $("[data-testimonial-quote]").each ->
      try

        allQuotes = $(this).attr("data-testimonial-quote").split(';');
        allIds = $(this).attr("data-testimonial-quote-ids").split(';');

        #allQuotes = JSON.parse $(this).attr("data-testimonial-quote")
        #.push $(this).attr('data-testimonial-quote')#.replace(/'/gi, '"')

        if allQuotes.length > 0 #Object.keys(allQuotes).length

          if $(this).attr("data-quote-randomize") is "" or $(this).attr("data-quote-randomize") is "true"
            shuffle(allQuotes, allIds)

          # if $(this).attr("data-quote-fixed") is "" or $(this).attr("data-quote-fixed") is "true"
          #   $(this).addClass("fixed")

          #$(this).addClass("quote-rotate")

          index = 0
          for q in allQuotes
            $("[data-quotes-holder]").append(generateBGDomElement(q, allIds[index]))
            index++


          $( $("[data-quotes-holder]").find(".quote-display")[0]).addClass("active")#.addClass("first")

          quoteContainer = $("[data-quotes-holder]")

          # if $("[data-quote-origin]").attr("data-quote-randomize") is "" or $("[data-quote-origin]").attr("data-quote-randomize") is "true"

          interval = setInterval ->
            quotes = quoteContainer.find(".quote-display")

            activeIndex = quoteContainer.find(".quote-display.active").index() + 1
            activeIndex = 0 if activeIndex > quotes.length - 1

            quotes.removeClass("active")
            $(quotes[activeIndex]).addClass("active")
          , 1000

          rotationIntervals.push interval
