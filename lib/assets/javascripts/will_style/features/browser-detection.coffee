isiOS = ->
  navigator and navigator.platform.match(/iP(hone|od|ad)/) isnt null

$(document).on window.WILLStyle.Settings.pageChangeEvent, ->

  # Add iOS class to the HTML Page

  if isiOS()
    $("html").addClass("ios")

