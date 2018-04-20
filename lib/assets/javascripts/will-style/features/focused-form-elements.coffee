$(document).on "focus", "input, textarea", (event)->
  $(event.currentTarget).closest(".form-container").addClass("focus") if $(event.currentTarget).closest(".form-container").length > 0

$(document).on "blur", "input, textarea", (event)->
  $(event.currentTarget).closest(".form-container").removeClass("focus") if $(event.currentTarget).closest(".form-container").length > 0