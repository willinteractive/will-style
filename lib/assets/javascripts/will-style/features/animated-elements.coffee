#----------------------------------------------------------------------------------------------
# This class will add before, after and active classes to elements with an animating property -
#----------------------------------------------------------------------------------------------

#---------------------
# Private Constants  -
#---------------------

_animatedElementSelector = "[data-animated]"
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
_cachedWindowHeight = -1
_cachedElements = undefined

_heightCache = {}
_targetCache = {}

#---------------------
# Private Methods    -
#---------------------

_generateID = ->
  'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
    r = Math.random() * 16 | 0
    v = if c == 'x' then r else r & 0x3 | 0x8
    v.toString 16

_getTargetForElement = (element) ->
  # Pull element from target cache if it's there
  return _targetCache[element.data("animate-id")] if _targetCache[element.data("animate-id")]

  # If target is inside the element, return it
  if element.find(element.data("animated-target")).length > 0
    target = element.find(element.data("animated-target"))[0]
    _targetCache[element.data("animate-id")] = target

    return target

  # Loop through parents to find target
  parent = element.parent()
  iterations = 0

  while iterations++ < 100
    targets = parent.find(element.data("animated-target"))

    if targets.length > 0
      target = targets[0]
      _targetCache[element.data("animate-id")] = target

      return target

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

  _cachedElements = $(_animatedElementSelector) unless _cachedElements

  _cachedElements.each ->
    element = $(this)

    # Don't bother with calculations if we're already active and we don't need progressive stuff
    return if element.data("animated-active")? and not element.data("animated-progressive")?

    targetTop = -1
    targetHeight = -1

    target = element

    # Set animation ids for cache reference
    target.data("animate-id", _generateID()) unless target.data("animate-id")
    element.data("animate-id", _generateID()) unless element.data("animate-id")

    # If we're using another element for targeting, use it
    if element.data("animated-target")?
      potentialTarget = _getTargetForElement(element)
      target = $(potentialTarget) if potentialTarget

    if target.data("animate-id") and _heightCache[target.data("animate-id")]
      targetTop = _heightCache[target.data("animate-id")].top
      targetHeight = _heightCache[target.data("animate-id")].height

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

      totalDistance = windowHeight + targetHeight
      traveledDistance = targetBottom - windowTop

      progressivePosition = Math.floor((totalDistance - traveledDistance) / totalDistance * 100)

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
  _targetCache = {}

  _cachedScrollTop = -1
  _cachedWindowHeight = -1
  _cachedElements = undefined

  _setupImageLoading()
  _scheduleAnimatedElementsUpdate()
