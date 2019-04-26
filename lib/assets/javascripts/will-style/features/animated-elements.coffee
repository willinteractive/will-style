#----------------------------------------------------------------------------------------------
# This class will add before, after and active classes to elements with an animating property -
#----------------------------------------------------------------------------------------------

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
_cachedWindowHeight = -1
_cachedElements = undefined

_heightCache = {}
_targetCache = {}

_cssInitialized = true

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
  parents = element.parents(element.data("animated-target"))

  if parents.length > 0
    target = parents[0]
    _targetCache[element.data("animate-id")] = target

    return target

  # Loop through parents' siblings to find target
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
  return if _cssInitialized is false

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

    # Do each calculation asynchronously to prevent lag
    setTimeout ->
      targetTop = -1
      targetHeight = -1

      target = element

      # Set animation ids for cache reference
      element.data("animate-id", _generateID()) unless element.data("animate-id")

      # If we're using another element for targeting, use it
      if element.data("animated-target")?
        potentialTarget = _getTargetForElement(element)
        target = $(potentialTarget) if potentialTarget

        target.data("animate-id", _generateID()) unless target.data("animate-id")

      if target.data("animate-id") and _heightCache[target.data("animate-id")]
        targetTop = _heightCache[target.data("animate-id")].top
        targetHeight = _heightCache[target.data("animate-id")].height

      if targetTop < 1
        targetTop = target.offset().top
        targetHeight = target.outerHeight()

        _heightCache[target.data("animate-id")] =
          top: targetTop
          height: targetHeight

      # Remove scroll top if element is data-animation-fixed
      if element.data("animated-fixed")?
        targetTop -= windowTop

      isActive = false

      # Element is fully visible
      if targetTop + targetHeight < windowTop + windowHeight
        isActive = true

      # Element is at top and we're only using the top as a trigger
      else if element.data("animated-begin")? and targetTop < windowTop + windowHeight
        isActive = true

      # Element is just past the top and we're only using the top as a trigger
      else if element.data("animated-visible")? and targetTop + (targetHeight * 0.1) < windowTop + windowHeight
        isActive = true

      if isActive
        element.attr("data-animated-active", "true")
      else if element.data("animated-hidden-before")?
        element.removeAttr("data-animated-active")

      # Element is completely off the screen
      if targetTop + targetHeight < windowTop
        element.attr("data-animated-after", "true")
      else
        element.removeAttr("data-animated-after")

      # Set progressive classes if element is asking for it
      if element.data("animated-progressive")?
        targetBottom = targetTop + targetHeight

        progressivePosition = 0

        totalDistance = windowHeight + targetHeight
        traveledDistance = targetBottom - windowTop

        if element.data("animated-begin")?
          totalDistance = windowHeight
          traveledDistance = targetTop - windowTop

        progressivePosition = Math.floor((totalDistance - traveledDistance) / totalDistance * 100)

        progressivePosition = 0 if progressivePosition < 0
        progressivePosition = 100 if progressivePosition > 100

        if progressivePosition > 0
          element.attr("data-animated-progressive-position", progressivePosition)
        else
          element.removeAttr("data-animated-progressive-position")
    , 0

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

_resetAnimationCache = ->
  _heightCache = {}
  _targetCache = {}

  _cachedScrollTop = -1
  _cachedWindowHeight = -1
  _cachedElements = undefined

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

    _resetAnimationCache()

$(document).on window.WILLStyle.Settings.pageChangeEvent, (event) ->
  _resetAnimationCache()
  _scheduleAnimatedElementsUpdate()

$(document).on 'turbolinks:before-render', (event) ->
  $(_staticAnimatedElementSelector).each ->
    element = $(this)

    if element.attr("data-animated-active")? and element.attr("id") isnt ""
      $(event.originalEvent.data.newBody).find("##{element.attr("id")}").attr("data-animated-active", true)
      $(event.originalEvent.data.newBody).find("##{element.attr("id")}").attr("data-animated-active-init", true)

window.WILLStyle.Events.on "update-animated-elements", ->
  _scheduleAnimatedElementsUpdate()

window.WILLStyle.Events.on "reset-animated-elements", ->
  _resetAnimationCache()
  _scheduleAnimatedElementsUpdate()

window.WILLStyle.Events.on "css-initialized", ->
  _cssInitialized = true

  _resetAnimationCache()
  _scheduleAnimatedElementsUpdate()

window.WILLStyle.Events.on "image-loaded", (image) ->
  if image.css("position") is "static" or image.css("position") is "relative"
    _resetAnimationCache()

#---------------------
# Initialization     -
#---------------------

if window.WILLStyle.Settings.synchronousCSS is false
  _cssInitialized = false
