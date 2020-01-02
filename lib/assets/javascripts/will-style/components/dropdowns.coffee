#
# Adding functionality to the bootstrap dropdowns
#

highlightDropdown = (dropdown) ->
  return unless $("html").hasClass("no-touchevents")

  if dropdown
    $(dropdown).addClass("show")
    $(dropdown).find(".dropdown-menu").addClass("show")

hideDropdown = (dropdown) ->
  return unless $("html").hasClass("no-touchevents")

  if dropdown
    $(dropdown).removeClass("show")
    $(dropdown).find(".dropdown-menu").removeClass("show")

$(document).on "mouseenter", ".dropdown-toggle, .dropdown-menu", (event) ->
  highlightDropdown $(event.currentTarget).closest(".dropdown")
  return true

$(document).on "mouseleave", ".dropdown-toggle, .dropdown-menu", (event) ->
  hideDropdown $(event.currentTarget).closest(".dropdown")
  return true
