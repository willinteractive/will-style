rotationInterval = undefined
rotationIndex = 0

parts = []

selectItem = (screen) ->
  $(".rotating-headline-part.active").addClass("inactive")
  $(".rotating-headline-part").removeClass("active")

  $(screen).removeClass("inactive").addClass("active")

  newRotationIndex = parts.indexOf(screen) + 1
  if newRotationIndex < parts.length then rotationIndex = newRotationIndex else rotationIndex = 0

initializeRotatingHeadlines = ->
  if rotationInterval
    clearInterval(rotationInterval)

  rotationInterval = undefined
  rotationIndex = 0

  if $(".rotating-headline-part").length > 0
    parts = []
    $(".rotating-headline-part").each ->
      parts.push this

    rotationInterval = setInterval ->
      selectItem(parts[rotationIndex])
    , 3000

    selectItem(parts[0])

$(document).on 'turbolinks:load', (event) ->
  initializeRotatingHeadlines()
