$(document).on "click", "[data-hero-arrow]", (event) ->
  $('html, body').animate
    scrollTop: $(window).outerHeight()
  , 1000