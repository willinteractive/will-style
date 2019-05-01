rotationInterval = undefined
rotationIndex = 0

screens = []

selectItem = (screen) ->
  $("[data-rotating-computer-screen]").removeClass("active").removeClass("first")
  $(screen).addClass("active")

$(document).on 'turbolinks:load', (event) ->
  if rotationInterval
    clearInterval(rotationInterval)

  rotationInterval = undefined
  rotationIndex = 0

  if $("[data-rotating-computer]").length > 0
    screens = []
    $("[data-rotating-computer-screen]").each ->
      screens.push this

    rotationInterval = setInterval ->
      selectItem(screens[rotationIndex])
      if rotationIndex < screens.length - 1 then rotationIndex++ else rotationIndex = 0
    , 10000

    $(screens[0]).addClass("first").addClass("active")
