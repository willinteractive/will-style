# Infinite scrolling carousel

# --------------------
# Private Constants  -
# --------------------

carouselElementProperty = "data-carousel-element"
carouselVisibleProperty = "data-carousel-visible"
carouselTargetProperty  = "data-carousel-target"
carouselActiveProperty  = "data-carousel-active"
carouselAddNextProperty = "data-carousel-add-next"
carouselLinkProperty    = "data-carousel-link"

carouselSelector              = "[data-carousel]"
carouselInnerSelector         = "[data-carousel-inner]"
carouselElementSelector       = "[#{carouselElementProperty}]"
carouselVisibleSelector       = "[#{carouselVisibleProperty}]"
carouselAddNextSelector       = "[#{carouselAddNextProperty}]"
carouselLinkSelector          = "[#{carouselLinkProperty}]"
carouselPreviousArrowSelector = "[data-carousel-arrow-previous]"
carouselNextArrowSelector     = "[data-carousel-arrow-next]"


carouselActiveClass = "active"
carouselBeforeClass = "before"
carouselAfterClass  = "after"

# --------------------
# Private Variables  -
# --------------------

updateTimer = undefined
isUpdating = false
requiresUpdate = false

isThrottled = false
throttleTimer = undefined

# --------------------
# PRIVATE FUNCTIONS  -
# --------------------

moveBackwards = (carousel) ->
  carouselInner = $(carousel).find(carouselInnerSelector)
  elements = $(carousel).find(carouselElementSelector)

  visibleElement = $(carousel).find("#{carouselVisibleSelector}")

  if visibleElement.length is 0
    visibleElement = $($(carousel).find(carouselElementSelector)[0])

  # Slide carousel over
  if visibleElement.length > 0 and visibleElement.prev().length > 0
    carouselInner.css({
      transition: ""
      transform: "translateX(#{0 - ($(carousel).offset().left + visibleElement.prev().position().left)}px)"
    })

    # Set up for next carousel image
    elements.removeAttr(carouselVisibleProperty)
    visibleElement.prev().attr(carouselVisibleProperty, true)

  # Activate next element if previous element was active
  if visibleElement.hasClass(carouselActiveClass)
    selectElement visibleElement.prev()

  # Disable previous button if we can't go back any farther
  if visibleElement.prev().length is 0 or visibleElement.prev().prev().length is 0
    $(carousel).find(carouselPreviousArrowSelector).attr("disabled", "disabled")

moveForwards = (carousel) ->
  carouselInner = $(carousel).find(carouselInnerSelector)
  elements = $(carousel).find(carouselElementSelector)

  visibleElement = $(carousel).find("#{carouselVisibleSelector}")

  if visibleElement.length is 0
    visibleElement = $($(carousel).find(carouselElementSelector)[0])

  # Slide carousel over
  if visibleElement.length > 0 and visibleElement.next().length > 0
    offset = visibleElement.next().position().left

    # Activate next element if previous element was active
    if visibleElement.hasClass(carouselActiveClass)
      selectElement visibleElement.next()
      widthDiff = visibleElement.outerWidth() * (visibleElement[0].getBoundingClientRect().width / visibleElement[0].offsetWidth) - visibleElement.outerWidth()
      offset = offset - widthDiff

    carouselInner.css({
      transition: ""
      transform: "translateX(#{0 - ($(carousel).offset().left + offset)}px)"
    })

    # Add extra carousel element at the end
    nextElement = $(carousel).find("#{carouselAddNextSelector}")

    if nextElement.length is 0
      nextElement = $($(carousel).find(carouselElementSelector)[0])

    nextElement.clone()
               .removeClass(carouselActiveClass)
               .removeClass(carouselBeforeClass)
               .removeClass(carouselActiveClass)
               .removeAttr(carouselVisibleProperty)
               .removeAttr(carouselAddNextProperty)
               .appendTo(carouselInner[0])

    elements.removeAttr(carouselAddNextProperty)
    nextElement.next().attr(carouselAddNextProperty, true)

    # Set up for next carousel image
    elements.removeAttr(carouselVisibleProperty)
    visibleElement.next().attr(carouselVisibleProperty, true)

    $(carousel).find(carouselPreviousArrowSelector).removeAttr("disabled")

    setBeforeAndAfterClasses(carousel)

selectElement = (element) ->
  return false if $(element).hasClass(carouselActiveClass)

  carousel = $(element).closest(carouselSelector)

  # Make the clicked element active
  carousel.find("#{carouselElementSelector}.#{carouselActiveClass}").removeClass(carouselActiveClass)
  $(element).addClass(carouselActiveClass)

  # Make any associated elements active
  $("[#{carouselTargetProperty}=#{carousel.attr("data-carousel")}].#{carouselActiveClass}").removeClass(carouselActiveClass)
  activeElements = $("[#{carouselTargetProperty}=#{carousel.attr("data-carousel")}][#{carouselActiveProperty}=#{$(element).attr(carouselElementProperty)}]")

  # Re-animate any previously animated elements
  # @NOTE: This is a bit hacky, but it's OK to rely on other internal libraries until they're actual plugins
  animatedElements = activeElements.find("[data-animated-active='true']")
  animatedElements.removeAttr("data-animated-active")

  setTimeout ->
    animatedElements.attr("data-animated-active", true)
  , 100

  activeElements.addClass(carouselActiveClass)

  setBeforeAndAfterClasses(carousel)

  return true

setBeforeAndAfterClasses = (carousel) ->
  carousel.find("#{carouselElementSelector}")
          .removeClass(carouselBeforeClass)
          .removeClass(carouselAfterClass)

  activeElement = carousel.find("#{carouselElementSelector}.#{carouselActiveClass}")
  activeIndex = activeElement.index()

  carousel.find("#{carouselElementSelector}").each ->
    if $(this).index() < activeIndex
      $(this).addClass(carouselBeforeClass)
    else if $(this).index() > activeIndex
      $(this).addClass(carouselAfterClass)

updateCarouselPositions = ->
  if isUpdating is true
    requiresUpdate = true
    return

  $(carouselSelector).each ->
    carouselInner = $(this).find(carouselInnerSelector)
    visibleElement = $(this).find("#{carouselVisibleSelector}")

    if visibleElement.length is 0
      visibleElement = $($(this).find(carouselElementSelector)[0])

    # Resize carousel correctly
    if visibleElement.length > 0
      carouselInner.css({
        transition: "none"
        transform: "translateX(#{0 - ($(this).offset().left + visibleElement.position().left)}px)"
      })

  clearTimeout(updateTimer) if updateTimer

  updateTimer = setTimeout ->
    isUpdating = false
    updateCarouselPositions() if requiresUpdate is true
  , 1000 / 100

throttleClicks = ->
  isThrottled = true
  throttleTimer = setTimeout ->
    isThrottled = false
  , 800

# --------------------
# EVENTS             -
# --------------------

$(document).on "click", carouselPreviousArrowSelector, (event) ->
  return if isThrottled is true

  moveBackwards $(this).closest(carouselSelector)
  throttleClicks()

$(document).on "click", carouselNextArrowSelector, (event) ->
  return if isThrottled is true

  moveForwards $(this).closest(carouselSelector)
  throttleClicks()

$(document).on "click", carouselElementSelector, (event) ->
  if selectElement(this)
    event.stopImmediatePropagation()
    return false

$(document).on "click", carouselLinkSelector, (event) ->
  return if $(this).attr(carouselLinkProperty) is ""

  if $(this).hasClass(carouselActiveClass) or $(this).closest(carouselElementSelector).hasClass(carouselActiveClass)
    window.location.href = $(this).attr(carouselLinkProperty)

$(window).on "resize", (event) ->
  if isUpdating is true
    requiresUpdate = true
    return

  if window.requestAnimationFrame
    window.requestAnimationFrame(updateCarouselPositions)
  else
    updateCarouselPositions()

$(document).on "turbolinks:load", ->
  # Disable previous button
  $(carouselPreviousArrowSelector).attr("disabled", "disabled")

  # Activate first item in each carousel
  $(carouselSelector).each ->
    if $(this).find(carouselElementSelector).length > 0
      selectElement $(this).find(carouselElementSelector)[0]

  setTimeout ->
    updateCarouselPositions()
  , 600
