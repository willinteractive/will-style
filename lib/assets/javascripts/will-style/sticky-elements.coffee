lastScrollPosition = undefined
lastWindowHeight = undefined
lastWindowWidth = undefined

requiresScrollCheck = false

$(document).on "scroll", ->
  if $(window).scrollTop() isnt lastScrollPosition or $(window).height() isnt lastWindowHeight or $(window).width() isnt lastWindowWidth
    requiresScrollCheck = true

  lastScrollPosition = $(window).scrollTop()
  lastWindowHeight = $(window).height()
  lastWindowWidth = $(window).width()

checkScroll = ->
  windowHeight = $(window).height()

  $(".sticky").each ->
    shouldStick = false

    element = $(this)

    if element.outerHeight() < windowHeight
      if element.parent().offset().top <= $(window).scrollTop()
        shouldStick = true

    if shouldStick
      element.addClass("is-fixed")
    else
      element.removeClass("is-fixed")

windowScrollChecker = setInterval ->
  if requiresScrollCheck
    requiresScrollCheck = false
    checkScroll()
, 1000 / 24
