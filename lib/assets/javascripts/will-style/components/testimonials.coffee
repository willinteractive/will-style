rotationInterval = undefined
testimonialButtons = []
rotationIndex = 0

shuffle = (array) ->
  i = array.length - 1

  while i > 0
    j = Math.floor(Math.random() * (i + 1))
    temp = array[i]
    array[i] = array[j]
    array[j] = temp
    i--

selectTestimonial = (testimonialButton) ->
  return unless $(testimonialButton).attr("data-testimonial-id")

  $("[data-testimonial-link]").removeClass("active")
  $(testimonialButton).addClass("active")

  $("[data-testimonial-item]").removeClass("active")
  selector = "##{$(testimonialButton).attr("data-testimonial-id")}"

  $(selector).removeAttr("data-animated-active")
  $(selector).addClass("active")

  setTimeout ->
    $(selector).attr("data-animated-active", true)
  , 10

resetRandomTestimonialRotation = ->
  if rotationInterval
    clearInterval(rotationInterval)

  rotationInterval = undefined
  rotationIndex = 0

$(document).on "click", "[data-testimonial-link]", (event) ->
  selectTestimonial(this)
  resetRandomTestimonialRotation()

  event.stopImmediatePropagation()
  event.stopPropagation()
  return false

$(document).on 'turbolinks:load', (event) ->
  resetRandomTestimonialRotation()

  if $("[data-testimonial-link]").length > 0
    testimonialButtons = []
    $("[data-testimonial-link]").each ->
      testimonialButtons.push this

    shuffle(testimonialButtons)

    rotationInterval = setInterval ->
      selectTestimonial(testimonialButtons[rotationIndex])

      if rotationIndex < testimonialButtons.length - 1 then rotationIndex++ else rotationIndex = 0
    , 10000

    selectTestimonial(testimonialButtons[0])
