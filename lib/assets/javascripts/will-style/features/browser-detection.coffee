isiOS = ->
  navigator and navigator.platform.match(/iP(hone|od|ad)/) isnt null

# @NOTE: This is based on some junk science and will break when the iPhone 11 Plus comes out
isiPhoneX = ->
  # Get the device pixel ratio
  ratio = window.devicePixelRatio or 1

  # Define the users device screen dimensions
  screen =
    width: window.screen.width * ratio
    height: window.screen.height * ratio

  return isiOS() and screen.width is 1125 and screen.height is 2436

$(document).on window.WILLStyleSettings.pageChangeEvent, ->

  # Add iOS class to the HTML Page

  if isiOS()
    $("html").addClass("ios")

  if isiPhoneX()
    $("html").addClass("iphone-x")
