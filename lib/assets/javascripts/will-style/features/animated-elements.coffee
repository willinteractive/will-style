# @TODO: Handle parallax-0 to parallax-100

#------------------------------------------------------------------------------------------
# This class will add before, after and active classes to elements with an animating property -
#------------------------------------------------------------------------------------------

#---------------------
# Private Constants  -
#---------------------

_animatedElementSelector = "[data-animated]"
_frameRate = 1000 / 12

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
_cachedWindowHeight = -1
_heightCache = {}

#---------------------
# Private Methods    -
#---------------------

_generateID = ->
  'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
    r = Math.random() * 16 | 0
    v = if c == 'x' then r else r & 0x3 | 0x8
    v.toString 16

_getTargetForElement = (element) ->
  # If target is inside the element, return it
  if element.find(element.data("animated-target")).length > 0
    return element.find(element.data("animated-target"))[0]

  # Loop through parents to find target
  parent = element.parent()
  iterations = 0

  while iterations++ < 100
    targets = parent.find(element.data("animated-target"))

    if targets.length > 0
      return targets[0]

    parent = parent.parent()

  return undefined

_updateAnimatedElements = ->
  if _isUpdating is true
    _requiresUpdate = true
    return

  if _cachedScrollTop is -1
    _cachedScrollTop =  $(window).scrollTop()

  if _cachedWindowHeight is -1
    _cachedWindowHeight = $(window).outerHeight()

  _requiresUpdate = false
  _isUpdating = true

  windowHeight = _cachedWindowHeight

  windowTop = _cachedScrollTop
  windowCenter = windowHeight / 2 + windowTop
  windowBottom = windowHeight + windowTop

  $(_animatedElementSelector).each ->
    element = $(this)

    targetTop = -1
    targetHeight = -1

    target = element

    # If we're using another element for targeting, use it
    if element.data("animated-target")?
      potentialTarget = _getTargetForElement(element)

      if potentialTarget
        target = $(potentialTarget)

    if target.data("animate-id") and _heightCache[target.data("animate-id")]
      targetTop = _heightCache[target.data("animate-id")].top
      targetHeight = _heightCache[target.data("animate-id")].height
    else unless target.data("animate-id")
      target.data("animate-id", _generateID())

    if targetTop < 1
      targetTop = target.offset().top
      targetHeight = target.outerHeight()

      _heightCache[target.data("animate-id")] =
        top: targetTop
        height: targetHeight

    # Element is fully visible
    if targetTop + targetHeight < windowTop + windowHeight
      element.attr("data-animated-active", "true")

    # Set progressive classes if element is asking for it
    if element.data("animated-progressive")?
      targetBottom = targetTop + targetHeight

      progressivePosition = 0

      # @TODO: position 0 is correct but position 100 is when the top of the element is at the top of the window
      travelDistance = windowHeight + targetHeight
      progressivePosition = Math.floor(Math.abs(1.0 - travelDistance / (targetBottom - windowTop)) * 100)

      progressivePosition = 0 if progressivePosition < 0
      progressivePosition = 100 if progressivePosition > 100

      if progressivePosition > 0
        element.attr("data-animated-progressive-position", progressivePosition)
      else
        element.removeAttr("data-animated-progressive-position")

  clearTimeout(_updateTimer) if _updateTimer

  _updateTimer = setTimeout ->
    _isUpdating = false
    _scheduleAnimatedElementsUpdate() if _requiresUpdate is true
  , _frameRate

_scheduleAnimatedElementsUpdate = ->
  if _isUpdating is true
    _requiresUpdate = true
    return

  if window.requestAnimationFrame
    window.requestAnimationFrame(_updateAnimatedElements)
  else
    _updateAnimatedElements()

_setupImageLoading = ->
  if $(_animatedElementSelector).length > 0
    $("img").each ->
      image = $(this)

      _loadTimeout = undefined

      _onLoad = ->
        clearTimeout _loadTimeout if _loadTimeout

        element = image.closest(_animatedElementSelector)
        if element and element.data("animate-id") and _heightCache[element.data("animate-id")]
          delete _heightCache[element.data("animate-id")]

        _scheduleAnimatedElementsUpdate()

      # If the image is already loaded, trigger loaded
      if image.context and (image.context.readyState is 4 or image.context.complete)
        _onLoad()

      # Otherwise, set a timeout to ensure we don't sit in loading forever
      else
        _loadTimeout = setTimeout _onLoad, 5000

        $(this).on 'load', _onLoad
        $(this).on 'error', _onLoad

#---------------------
# Observers          -
#---------------------

$(window).on "scroll", ->
  if $(window).scrollTop() isnt _lastScrollTop
    _cachedScrollTop = -1
    _scheduleAnimatedElementsUpdate()

$(window).on "resize", ->
  if $(window).outerHeight() isnt _lastWindowHeight or $(window).outerWidth() isnt _lastWindowWidth
    _lastWindowHeight = $(window).outerHeight()
    _lastWindowWidth = $(window).outerWidth()

    _cachedWindowHeight = -1
    _heightCache = {}

    _scheduleAnimatedElementsUpdate()

$(document).on 'turbolinks:load', ->
  _heightCache = {}
  _cachedScrollTop = -1
  _cachedWindowHeight = -1

  _setupImageLoading()
  _scheduleAnimatedElementsUpdate()
