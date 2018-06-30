# Add collapsing out functionality to the navbar on small screens
$(document).on "click tap", ".navbar-toggler", (event)->
  button = $(event.currentTarget)
  if button.attr("aria-expanded") is "false"
    menu = button.siblings(".navbar-collapse")
    menu.addClass("collapsing-out")

    iterationCount = 0
    checkInterval = setInterval ->
      if menu.hasClass("collapsing") is false or iterationCount++ > 100
        menu.removeClass("collapsing-out")

        if checkInterval
          clearInterval(checkInterval)
          checkInterval = undefined
    , 1000 / 4

# Adding ability for the navbar to obscure content

#---------------------
# Private Constants  -
#---------------------

_animatedElementSelector = "[data-animated]"
_staticAnimatedElementSelector = "[data-animated-static]"
_frameRate = 1000 / 60

#---------------------
# Private Properties -
#---------------------

_lastScrollTop = -1
_lastWindowHeight = -1
_lastWindowWidth = -1

_updateTimer = undefined
_isUpdating = false
_requiresUpdate = false

_cachedScrollTop = -1
_cachedNavbarHeight = -1

_updateNavbarObscure = ->
  navbar = $(".navbar")
  obscure = $("[data-navbar-obscure]")

  return unless obscure.length > 0 and navbar.length > 0

  if _isUpdating is true
    _requiresUpdate = true
    return

  if _cachedScrollTop is -1
    _cachedScrollTop =  $(window).scrollTop()

  if _cachedNavbarHeight is -1
    _cachedNavbarHeight = navbar.outerHeight()

  _requiresUpdate = false
  _isUpdating = true

  if obscure.offset().top < (_cachedScrollTop + _cachedNavbarHeight)
    navbar.addClass("obscure")
  else
    navbar.removeClass("obscure")

  clearTimeout(_updateTimer) if _updateTimer

  _updateTimer = setTimeout ->
    _isUpdating = false
    _scheduleNavbarObscureUpdate() if _requiresUpdate is true
  , _frameRate

_scheduleNavbarObscureUpdate = ->
  if _isUpdating is true
    _requiresUpdate = true
    return

  if window.requestAnimationFrame
    window.requestAnimationFrame(_updateNavbarObscure)
  else
    _updateNavbarObscure()

$(window).on "scroll", ->
  if $(window).scrollTop() isnt _lastScrollTop
    _cachedScrollTop = -1
    _scheduleNavbarObscureUpdate()

$(window).on "resize", ->
  if $(window).outerHeight() isnt _lastWindowHeight or $(window).outerWidth() isnt _lastWindowWidth
    _lastWindowHeight = $(window).outerHeight()
    _lastWindowWidth = $(window).outerWidth()

    _cachedScrollTop = -1
    _cachedNavbarHeight = -1

    _scheduleNavbarObscureUpdate()
