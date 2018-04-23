$(document).on "focus", "input, textarea", (event)->
  $(event.currentTarget).closest(".form-container").addClass("focus") if $(event.currentTarget).closest(".form-container").length > 0

$(document).on "blur", "input, textarea", (event)->
  $(event.currentTarget).closest(".form-container").removeClass("focus") if $(event.currentTarget).closest(".form-container").length > 0

$(document).on "mouseenter", "input", (event)->
  $(event.currentTarget).closest(".button-container").addClass("hover")

$(document).on "mouseleave", "input", (event)->
  $(event.currentTarget).closest(".button-container").removeClass("hover")
