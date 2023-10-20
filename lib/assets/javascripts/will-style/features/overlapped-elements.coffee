#----------------------------------------------------------------------------------------------
# This class will add negative 50% height margins to elements with overlap props              -
#----------------------------------------------------------------------------------------------

#---------------------
# Private Constants  -
#---------------------

_elementSelector = "[overlap]"
_parentSelector = "[overlap-parent]"
_afterSelector = "[overlap-after]"
_frameRate = 1000 / 60

_maximumAnimationDuration = 800

#---------------------
# Private Properties -
#---------------------

_lastWindowHeight = -1
_lastWindowWidth = -1

_updateTimer = undefined
_isUpdating = false
_requiresUpdate = false

_resetTimer = undefined

_updateOverlappedElements = ->
  if _isUpdating is true
    _requiresUpdate = true
    return

  _requiresUpdate = false
  _isUpdating = true

  $(_elementSelector).each ->
    element = $(this)

    # Do each calculation asynchronously to prevent lag
    setTimeout ->
        element.css
            "transform": "translateY(-50%)"

        element.closest(_parentSelector).css
            "margin-top": "#{element.height() / 2}px"

        element.parent().find(_afterSelector).css
            "margin-top": "-#{element.height() / 2}px"
    , 0

  clearTimeout(_updateTimer) if _updateTimer

  _updateTimer = setTimeout ->
    _isUpdating = false
    _scheduleOverlappedElementsUpdate() if _requiresUpdate is true
  , _frameRate

_scheduleOverlappedElementsUpdate = ->
  if _isUpdating is true
    _requiresUpdate = true
    return

  if window.requestAnimationFrame
    window.requestAnimationFrame(_updateOverlappedElements)
  else
    _updateOverlappedElements()

#---------------------
# Observers          -
#---------------------

$(window).on "resize", ->
  if $(window).outerHeight() isnt _lastWindowHeight or $(window).outerWidth() isnt _lastWindowWidth
    _lastWindowHeight = $(window).outerHeight()
    _lastWindowWidth = $(window).outerWidth()

    _scheduleOverlappedElementsUpdate()

window.WILLStyle.Events.on "css-initialized", ->
  _scheduleOverlappedElementsUpdate()

window.WILLStyle.Events.on "image-loaded", (image) ->
  if image.css("position") is "static" or image.css("position") is "relative"
    _scheduleOverlappedElementsUpdate()

$(document).on window.WILLStyle.Settings.pageChangeEvent, (event) ->
  _updateOverlappedElements()

# Force element update on page change
$ ->
  _updateOverlappedElements()
