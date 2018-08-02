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

# Add class on navbar to make sure it's on top of content
$(document).on "click tap", ".navbar-toggler", (event)->
  button = $(event.currentTarget)

  if button.attr("aria-expanded") is "false"
    $("body").removeClass("navbar-active")
  else
    $("body").addClass("navbar-active")

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

_topCache = {}

#---------------------
# Private Methods    -
#---------------------

_generateID = ->
  'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
    r = Math.random() * 16 | 0
    v = if c == 'x' then r else r & 0x3 | 0x8
    v.toString 16

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

  shouldObscure = false

  obscure.each ->
    if $(this).is(":visible")
      # Set animation ids for cache reference
      $(this).data("obscure-id", _generateID()) unless $(this).data("obscure-id")

      elementTop = -1
      if _topCache[$(this).data("obscure-id")]
        elementTop = _topCache[$(this).data("obscure-id")].top

      if elementTop < 1
        elementTop = $(this).offset().top
        _topCache[$(this).data("animate-id")] = $(this).offset().top

      if elementTop < (_cachedScrollTop + _cachedNavbarHeight)
        shouldObscure = true

  if shouldObscure
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

#---------------------
# Observers          -
#---------------------

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

    _topCache = {}

    _scheduleNavbarObscureUpdate()

$(document).on window.WILLStyle.Settings.pageChangeEvent, ->
  _topCache = {}

  _cachedScrollTop = -1
  _cachedNavbarHeight = -1

  _scheduleNavbarObscureUpdate()
