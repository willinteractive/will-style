lastWindowHeight = 0
windowSizeObserver = undefined

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

    if popOut.find("iframe").length > 0
      $(popOut.find("iframe")).removeAttr("src")

    $("[data-pop-out-id='#{popOut.attr("id")}']").removeClass("selected")
    $("[data-pop-out-id='#{popOut.attr("id")}']").find("span").removeClass("selected")

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

  if link.attr("data-pop-out-id")
    popOut = $("##{link.attr("data-pop-out-id")}")

    if link.attr("data-pop-out-url")
      if $("html").hasClass("touch")
        window.open link.attr("data-pop-out-url"), '_blank'
        return

      if popOut.find("iframe").length is 0
        $(popOut.find(".content")).prepend("<iframe allowfullscreen></iframe>")

      iframe = $(popOut.find("iframe"))
      iframe.attr("src", link.attr("data-pop-out-url"))

      $("body").addClass("with-iframe")

    popOut.addClass("enabled")
    centerPopOut()

    popOut.appendTo("body")

    $("body").addClass("pop-out-showing")

    watchPopOut()

    if popOut.find("video").length > 0
      popOut.find("video")[0].play()
      popOut.find("video").on("ended", clearPopOut)

    event.stopImmediatePropagation()
    event.stopPropagation()

    return false

$(document).on "click", '.close-pop-out', clearPopOut

$(document).on "turbolinks:load", clearPopOut