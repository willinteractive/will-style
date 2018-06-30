
# I have to shuffle BOTH IDS and QUOTES b/c when I create the h1 elements below I add an id to them.
# I use that to find the right quote when I click an image.
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
  "<h1 id=#{index} class=\"quote-display text-light lead\" >#{quote}</h1>"

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

        # I need to pass in both the id and quotes b/c on click I need to be able to identify the quote that corresponds w/the image and display it on-screen.
        allQuotes = $(this).attr("data-testimonial-quote").split(';');
        allIds = $(this).attr("data-testimonial-quote-ids").split(';');

        if allQuotes.length > 0

          if $(this).attr("data-quote-randomize") is "" or $(this).attr("data-quote-randomize") is "true"
            shuffle(allQuotes, allIds)

          # I need to iterate over BOTH the quote array and the id array - so I use the index for ID iteration.
          index = 0
          for q in allQuotes
            $("[data-quotes-holder]").append(generateBGDomElement(q, allIds[index]))
            index++


          $( $("[data-quotes-holder]").find(".quote-display")[0]).addClass("active");
          $( $("[data-testimonial]").find(".quote-icon")[0]).addClass("active");

          quoteContainer = $("[data-quotes-holder]")
          iconContainer = $("[data-testimonial]")

          interval = setInterval ->
            quotes = quoteContainer.find(".quote-display")
            icons = iconContainer.find(".quote-icon")

            activeIndex = quoteContainer.find(".quote-display.active").index() + 1
            activeIndex = 0 if activeIndex > quotes.length - 1

            quotes.removeClass("active")
            icons.removeClass("active")

            $(quotes[activeIndex]).addClass("active")
            $(icons[activeIndex]).addClass("active")

          , 1000

          rotationIntervals.push interval
