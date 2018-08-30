lastWindowHeight = 0
windowSizeObserver = undefined

popOutOverlay = $('<div class="pop-out-overlay"></div>')

watchPopOut = ->
  lastWindowHeight = 0
  setInterval ->
    windowHeight = $(window).height()

    if lastWindowHeight isnt windowHeight
      centerPopOut()

    lastWindowHeight = windowHeight
  , 1000 / 4

clearPopOut = ->
  if windowSizeObserver
    clearInterval windowSizeObserver
    windowSizeObserver = undefined

  popOut = $('[data-pop-out=""].enabled')

  popOut.attr("id")
  $("body").removeClass("pop-out-showing")
  $("body").removeClass("with-iframe")

  if popOut.length > 0
    if popOut.find("video").length > 0
      popOut.find("video")[0].pause()
      popOut.find("video").off("ended")

    popOut.removeClass("enabled")
    popOutOverlay.removeClass("enabled")

    if popOut.find("iframe").length > 0
      if popOut.attr("data-pop-out-fullscreen") isnt ""
        $(popOut.find("iframe")).removeAttr("src")

    $("[data-pop-out-id='#{popOut.attr("id")}']").removeClass("selected")
    $("[data-pop-out-id='#{popOut.attr("id")}']").find("span").removeClass("selected")

    window.WILLStyle.Events.trigger "pop-out-hide", popOut.attr("id")

centerPopOut = ->
  popOut = $('[data-pop-out=""].enabled')

  if popOut.length > 0
    popOutHeight = popOut.outerHeight()
    windowHeight = $(window).height()

    if popOutHeight > windowHeight + 40 or popOut.hasClass("full")
      popOut.css
        top: "0px"
    else
      popOut.css
        top: (windowHeight - popOutHeight) / 2 + "px"

$(document).on "click", '[data-pop-out-link=""]', (event) ->
  return if $('[data-pop-out=""].enabled').length > 0

  link = $(event.currentTarget)

  if link.attr("data-pop-out-active-class") and not link.hasClass(link.attr("data-pop-out-active-class"))
    return

  if link.attr("data-pop-out-id")
    popOut = $("##{link.attr("data-pop-out-id")}")

    if link.attr("data-pop-out-url")
      if $("html").hasClass("touch") and popOut.attr("data-pop-out-fullscreen") isnt ""
        window.open link.attr("data-pop-out-url"), '_blank'
        return

      if popOut.find("iframe").length is 0
        $(popOut.find(".content")).prepend("<iframe allowfullscreen></iframe>")

      iframe = $(popOut.find("iframe"))

      if link.attr("data-pop-out-url") isnt iframe.attr("src")
        iframe.attr("src", link.attr("data-pop-out-url"))

      $("body").addClass("with-iframe")

    if popOut.attr("data-pop-out-fullscreen") isnt ""
      popOutOverlay.attr("data-pop-out-id", link.attr("data-pop-out-id"))
      popOutOverlay.appendTo("body")
      popOut.appendTo("body")

    popOut.addClass("enabled")
    popOutOverlay.addClass("enabled")
    centerPopOut()

    $("body").addClass("pop-out-showing")

    watchPopOut()

    if popOut.find("video").length > 0
      popOut.find("video")[0].play()
      popOut.find("video").on("ended", clearPopOut)

    window.WILLStyle.Events.trigger "pop-out-show", link.attr("data-pop-out-id")

    event.stopImmediatePropagation()
    event.stopPropagation()

    return false

$(document).on "click", '.close-pop-out', clearPopOut

$(document).on "turbolinks:load", clearPopOut

# Disable fullscreen for pop outs
$(document).on "webkitfullscreenchange mozfullscreenchange fullscreenchange MSFullscreenChange", (event) ->
  element = document.fullscreenElement or document.webkitFullscreenElement or document.mozFullScreenElement or document.msFullscreenElement

  if element and $(element).is("iframe")
    if document.exitFullscreen
      document.cancelFullscreen()
    else if document.mozCancelFullScreen
      document.mozCancelFullScreen()
    else if document.webkitCancelFullScreen
      document.webkitCancelFullScreen()
    else if document.msFullscreenElement
      document.msExitFullscreen()
