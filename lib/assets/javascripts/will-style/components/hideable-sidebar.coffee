# Hideable Sidebar functionality


$(document).on "click tap", "[data-hideable-sidebar-toggle]", (event) ->
  event.stopImmediatePropagation()
  event.stopPropagation()

  $(this).closest("[data-hideable-sidebar]").toggleClass("active")

  false
