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

# Allow togglers to be links to things
$(document).on "click", ".dropdown-toggle", (event) ->
  link = $(event.currentTarget).attr("href")

  if link isnt "" and link isnt "#"
    window.location.href = link
