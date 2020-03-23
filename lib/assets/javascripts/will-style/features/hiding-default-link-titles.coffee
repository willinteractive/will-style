# Remove and Re-Add link titles on links when hovering so we don't get browser pop-in

$(document).on "mouseenter", "a, button", (event) ->
  if $(event.currentTarget).attr("title")
    $(event.currentTarget).attr("data-hover-title", $(event.currentTarget).attr("title"))
    $(event.currentTarget).removeAttr("title")

$(document).on "mouseleave", "a, button", (event) ->
  if $(event.currentTarget).attr("data-hover-title")
    $(event.currentTarget).attr("title", $(event.currentTarget).attr("data-hover-title"))
    $(event.currentTarget).removeAttr("data-hover-title")
