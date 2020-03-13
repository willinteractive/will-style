rotationInterval = undefined
rotationTimeout = undefined

selectorButtons = []
rotationIndex = 1

selectItem = (selectorButton) ->
  return unless $(selectorButton).attr("data-selector-id")

  $("[data-selector-link]").removeClass("active")
  $(selectorButton).addClass("active")

  $("[data-selector-item]").removeClass("active")
  selector = "##{$(selectorButton).attr("data-selector-id")}"

  $(selector).removeAttr("data-animated-active")
  $(selector).addClass("active")

  setTimeout ->
    $(selector).attr("data-animated-active", true)
  , 10

resetSelectorRotation = ->
  if rotationInterval
    clearInterval(rotationInterval)

  rotationInterval = undefined
  rotationIndex = 1

  if rotationTimeout
    clearTimeout(rotationTimeout)

  rotationTimeout = undefined

checkForActiveSelectors = ->
  canInitialize = true

  if $("[data-selector-link]").closest("[data-animated]").length > 0
    unless $("[data-selector-link]").closest("[data-animated]").attr("data-animated-active")?
      canInitialize = false

  if canInitialize is true
    rotationInterval = setInterval ->
      selectItem(selectorButtons[rotationIndex])

      if rotationIndex < selectorButtons.length - 1 then rotationIndex++ else rotationIndex = 0
    , 10000
  else
    rotationTimeout = setTimeout checkForActiveSelectors, 1000 / 2

$(document).on "click", "[data-selector-link]", (event) ->
  selectItem(this)
  resetSelectorRotation()

  event.stopImmediatePropagation()
  event.stopPropagation()
  return false

$(document).on 'turbolinks:load', (event) ->
  resetSelectorRotation()

  if $("[data-selector-link]").length > 0
    selectorButtons = []
    $("[data-selector-link]").each ->
      selectorButtons.push this

    checkForActiveSelectors()

    selectItem(selectorButtons[0])
