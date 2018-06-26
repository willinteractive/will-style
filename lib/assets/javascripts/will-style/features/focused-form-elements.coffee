$(document).on "focus", "input, textarea", (event)->
  $(event.currentTarget).closest(".form-container").addClass("focus") if $(event.currentTarget).closest(".form-container").length > 0

$(document).on "blur", "input, textarea", (event)->
  $(event.currentTarget).closest(".form-container").removeClass("focus") if $(event.currentTarget).closest(".form-container").length > 0

$(document).on "mouseenter", "input", (event)->
  $(event.currentTarget).closest(".button-container").addClass("hover")

$(document).on "mouseleave", "input", (event)->
  $(event.currentTarget).closest(".button-container").removeClass("hover")

$(document).on "keyup keydown change blur", "input, textarea", (event)->
  if $(event.currentTarget).closest(".form-container").length > 0
    if $(event.currentTarget).val() is ""
      $(event.currentTarget).closest(".form-container").removeClass("entered")
    else
      $(event.currentTarget).closest(".form-container").addClass("entered")

$(document).on "change", "select", (event)->
  if $(event.currentTarget).data("selection-triggered") and $(event.currentTarget).closest(".form-container").length > 0
    $(event.currentTarget).closest(".form-container").addClass("entered")
  else
    $(event.currentTarget).data("selection-triggered", true)

$(document).on "mousedown mouseup", "select", (event)->
  if $(event.currentTarget).closest(".form-container").length > 0
    $(event.currentTarget).data("selection-triggered", true)
    $(event.currentTarget).closest(".form-container").addClass("entered")