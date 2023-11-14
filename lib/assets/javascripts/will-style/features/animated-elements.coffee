#----------------------------------------------------------------------------------------------
# This class will add before, after and active classes to elements with an animating property -
#----------------------------------------------------------------------------------------------

#---------------------
# Private Constants  -
#---------------------

_animatedElementSelector = "[animated]"
_staticAnimatedElementSelector = "[animated-static]"
_frameRate = 1000 / 60

_maximumAnimationDuration = 800

#---------------------
# Private Properties -
#---------------------

_lastScrollTop = -1
_lastWindowHeight = -1
_lastWindowWidth = -1

_updateTimer = undefined
_isUpdating = false
_requiresUpdate = false

_resetTimer = undefined

_cachedScrollTop = -1
_cachedWindowHeight = -1

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
  return _targetCache[element.attr("animate-id")] if _targetCache[element.attr("animate-id")]

  # If target is inside the element, return it
  if element.find(element.attr("animated-target")).length > 0
    target = element.find(element.attr("animated-target"))[0]
    _targetCache[element.attr("animate-id")] = target

    return target

  # Loop through parents to find target
  parents = element.parents(element.attr("animated-target"))

  if parents.length > 0
    target = parents[0]
    _targetCache[element.attr("animate-id")] = target

    return target

  # Loop through parents' siblings to find target
  parent = element.parent()
  iterations = 0

  while iterations++ < 100
    targets = parent.find(element.attr("animated-target"))

    if targets.length > 0
      target = targets[0]
      _targetCache[element.attr("animate-id")] = target

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

  _hasReset = false

  $(_animatedElementSelector).each ->
    element = $(this)

    # Do each calculation asynchronously to prevent lag
    setTimeout ->
      targetTop = -1
      targetHeight = -1

      target = element

      # Set animation ids for cache reference
      element.attr("animate-id", _generateID()) unless element.attr("animate-id")

      # If we're using another element for targeting, use it
      if element.attr("animated-target")?
        potentialTarget = _getTargetForElement(element)
        target = $(potentialTarget) if potentialTarget

        target.attr("animate-id", _generateID()) unless target.attr("animate-id")

      if target.attr("animate-id") and _heightCache[target.attr("animate-id")]
        targetTop = _heightCache[target.attr("animate-id")].top
        targetHeight = _heightCache[target.attr("animate-id")].height

      if targetTop < 1
        targetTop = target.offset().top
        targetHeight = target.outerHeight()

        _heightCache[target.attr("animate-id")] =
          top: targetTop
          height: targetHeight

      # Remove scroll top if element is data-animation-fixed
      if element.attr("animated-fixed")?
        targetTop -= windowTop

      isActive = false

      beginHeight = targetHeight * 0.1
      beginHeight = 15 if beginHeight > 15

      # Element is fully visible
      if targetTop + targetHeight < windowTop + windowHeight
        isActive = true

      # Element is at top and we're only using the top as a trigger
      else if element.attr("animated-begin")? and (targetTop + beginHeight) < windowTop + windowHeight
        isActive = true

      # Element is just past the top and we're only using the top as a trigger
      else if element.attr("animated-visible")? and targetTop + (targetHeight * 0.2) < windowTop + windowHeight
        isActive = true

      if isActive
        # Element animation determines the position of future elements, so it requires a remeasure
        if element.attr("animated-active") isnt "true" && element.attr("animated-reset")? && _hasReset is false
          _hasReset = true

          clearTimeout(_resetTimer) if _resetTimer

          _resetTimer = setTimeout ->
            _resetAnimationCache()

            _requiresUpdate = false
            _isUpdating = false

            _scheduleAnimatedElementsUpdate()
          , parseInt(element.attr("animated-reset")) || _maximumAnimationDuration

        element.attr("animated-active", "true")
      else if element.attr("animated-hidden-before")?
        element.removeAttr("animated-active")

      # Element is completely off the screen
      if targetTop + targetHeight < windowTop
        element.attr("animated-after", "true")
      else
        element.removeAttr("animated-after")

      # Set progressive classes if element is asking for it
      if element.attr("animated-progressive")?
        targetBottom = targetTop + targetHeight

        progressivePosition = 0

        totalDistance = windowHeight + targetHeight
        traveledDistance = targetBottom - windowTop

        if element.attr("animated-begin")?
          totalDistance = windowHeight
          traveledDistance = targetTop - windowTop

        progressivePosition = Math.floor((totalDistance - traveledDistance) / totalDistance * 100)

        progressivePosition = 0 if progressivePosition < 0
        progressivePosition = 100 if progressivePosition > 100

        if progressivePosition > 0
          element.attr("animated-progressive-position", progressivePosition)
        else
          element.removeAttr("animated-progressive-position")
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
    _scheduleAnimatedElementsUpdate()

$(document).on window.WILLStyle.Settings.pageChangeEvent, (event) ->
  _resetAnimationCache()
  _scheduleAnimatedElementsUpdate()

# Force animated element update on page change
$ ->
  _resetAnimationCache()
  _scheduleAnimatedElementsUpdate()

$(document).on 'turbolinks:before-render', (event) ->
  $(_staticAnimatedElementSelector).each ->
    element = $(this)

    if element.attr("animated-active")? and element.attr("id") isnt ""
      $(event.originalEvent.attr.newBody).find("##{element.attr("id")}").attr("animated-active", true)
      $(event.originalEvent.attr.newBody).find("##{element.attr("id")}").attr("animated-active-init", true)

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
