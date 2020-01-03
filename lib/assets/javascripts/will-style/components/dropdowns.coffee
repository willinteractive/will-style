#
# Adding functionality to the bootstrap dropdowns
#

highlightDropdown = (dropdown) ->
  return if $("html").hasClass("touchevents")

  if dropdown
    $(dropdown).addClass("show")
    $(dropdown).find(".dropdown-menu").addClass("show")

hideDropdown = (dropdown) ->
  return if $("html").hasClass("touchevents")

  if dropdown
    $(dropdown).removeClass("show")
    $(dropdown).find(".dropdown-menu").removeClass("show")

visitRootDropdown = (dropdown) ->
  link = dropdown.find(".dropdown-toggle").attr("href")

  if link and link isnt "" and link isnt "#"
    console.log link
    window.location.href = link

$(document).on "mouseenter focusin", ".dropdown-toggle, .dropdown-menu", (event) ->
  highlightDropdown $(event.currentTarget).closest(".dropdown")
  return true

$(document).on "mouseleave focusout", ".dropdown-toggle, .dropdown-menu", (event) ->
  hideDropdown $(event.currentTarget).closest(".dropdown")
  return true

# Allow togglers to be links to things

# Mouse-Based

$(document).on "click", ".dropdown-toggle", (event) ->
  return if $("html").hasClass("touchevents")

  visitRootDropdown $(event.currentTarget).closest(".dropdown")

# Touch-Based

$(document).on 'turbolinks:load', (event) ->
  return unless $("html").hasClass("touchevents")

  # On large screens, follow the dropdown link when the dropdown hides
  #
  # @NOTE: Disabling this for now until we figure out if we want it
  # $(".dropdown-toggle").on "click", (event) ->
  #   if $(event.currentTarget).closest(".dropdown").hasClass("show")
  #     visitRootDropdown $(event.currentTarget).closest(".dropdown")

  # On small screens, trigger click-through on first click
  $(".dropdown").on "show.bs.dropdown", (event) ->
    dropdown = $(event.currentTarget).closest(".dropdown")

    if dropdown.closest(".navbar-collapse").hasClass("collapse show")
      visitRootDropdown dropdown
