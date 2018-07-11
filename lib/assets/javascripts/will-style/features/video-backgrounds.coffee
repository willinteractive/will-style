#-------------------------------
# Full Frame Video Backgrounds -
#-------------------------------

#---------------------
# Private Constants  -
#---------------------

_frameRate = 1000 / 24

#---------------------
# Private Properties -
#---------------------

_lastScrollTop = -1
_lastWindowHeight = -1
_lastWindowWidth = -1

_updateTimer = undefined
_isUpdating = false
_requiresUpdate = false

_getAspectRatio = (video) ->
  if $(video)[0].videoWidth > 0 && video.currentTime > 0
    return $(video)[0].videoHeight / $(video)[0].videoWidth

  return 0

_initializeVideoElement = (video) ->
  if _getAspectRatio(video) isnt 0
    $(video).closest(".video-bg").addClass("loaded")
    _resizeVideoElement(video)

_initializeVideoElements = ->
  $("video").each ->
    _initializeVideoElement(this)

_resizeVideoElement = (video) ->
  if $(video).closest(".video-bg").length > 0
    windowWidth = $(video).closest(".video-bg").width()
    windowHeight = $(video).closest(".video-bg").height()
  else
    windowWidth = $(window).width()
    windowHeight = $(window).height()

  # If we're not visible, revisit in 100ms
  if windowWidth is 0 and windowHeight is 0
    setTimeout(->
      _resizeVideoElement(video)
    , 100)

  else
    windowAspectRatio = windowHeight / windowWidth
    elementAspectRatio = _getAspectRatio(video)

    return if elementAspectRatio is 0

    if windowAspectRatio <= elementAspectRatio
      newHeight = windowWidth * elementAspectRatio

      $(video).css
        width: windowWidth
        height: newHeight
        top: (windowHeight - newHeight) / 2
        left: 0

    else
      newWidth = windowHeight / elementAspectRatio

      $(video).css
        width: newWidth
        height: windowHeight
        top: 0
        left: (windowWidth - newWidth) / 2

_resizeVideoElements = ->
  $("video").each ->
    _resizeVideoElement(this)

_scheduleResizeVideoElements = ->
  if _isUpdating is true
    _requiresUpdate = true
    return

  _isUpdating = true

  _updateTimer = setTimeout ->
    _isUpdating = false

    if _requiresUpdate is true
      _requiresUpdate = false
      _scheduleResizeVideoElements()
  , _frameRate

  if window.requestAnimationFrame
    window.requestAnimationFrame(_resizeVideoElements)
  else
    _resizeVideoElements()

$(document).on window.WILLStyleSettings.pageChangeEvent, ->
  _initializeVideoElements()

  $("video").on "loadedmetadata timeupdate", (event) ->
    _initializeVideoElement(event.currentTarget)

$(window).on "resize", ->
  if $(window).outerHeight() isnt _lastWindowHeight or $(window).outerWidth() isnt _lastWindowWidth
    _lastWindowHeight = $(window).outerHeight()
    _lastWindowWidth = $(window).outerWidth()

    _scheduleResizeVideoElements()
