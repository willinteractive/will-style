#
# Adding functionality to the bootstrap dropdowns
#

currentDropdown = undefined

getDropdown = (dropdownToggle) ->
  if $(dropdownToggle).closest(".dropdown").length > 0
    $(dropdownToggle).closest(".dropdown")
  else if $(dropdownToggle).closest(".dropdown-menu[aria-labelledby]").length > 0
    $("##{$(dropdownToggle).closest(".dropdown-menu").attr('aria-labelledby')}").closest(".dropdown")

getDropdownMenu = (dropdown) ->
  if $(dropdown).find(".dropdown-menu").length > 0 and !$(dropdown).find(".dropdown-menu").hasClass("dropdown-small")
    $(dropdown).find(".dropdown-menu")
  else
    $(".dropdown-menu[aria-labelledby='#{$(dropdown).find(".dropdown-toggle").attr("id")}']")

highlightDropdown = (dropdownToggle, permanently = false) ->
  dropdown = getDropdown(dropdownToggle)

  return unless dropdown.length > 0

  if currentDropdown and currentDropdown isnt dropdown[0]
    currentDropdown = undefined

  # Clear all other dropdowns
  $(".dropdown, .dropdown-menu").removeClass("show")
  $(".dropdown-toggle").removeClass("active")

  dropdown.addClass("show")
  getDropdownMenu(dropdown).addClass("show") if getDropdownMenu(dropdown)

  if permanently is true
    currentDropdown = dropdown[0]

  # $(".dropdown-toggle").blur()

hideDropdown = (dropdownToggle) ->
  dropdown = getDropdown(dropdownToggle)

  return unless dropdown.length > 0
  return if currentDropdown

  $(dropdownToggle).blur()

  currentDropdown = undefined

  dropdown.removeClass("show")
  getDropdownMenu(dropdown).removeClass("show") if getDropdownMenu(dropdown)

clearAnimationClasses = (dropdownToggle) ->
  dropdown = getDropdown(dropdownToggle)

  return unless dropdown.length > 0

  dropdownMenu = getDropdownMenu(dropdown)

  $(dropdownToggle).removeClass("no-anim")
  dropdownMenu.removeClass("no-anim")

$(document).on "mouseenter focusin", ".dropdown-toggle", (event) ->
  clearAnimationClasses(event.currentTarget)

  highlightDropdown event.currentTarget
  return true

$(document).on "mouseleave focusout", ".dropdown-toggle, .dropdown-menu", (event) ->
  return unless event and event.originalEvent and event.originalEvent.clientX and event.originalEvent.clientY

  currentElement = $(document.elementFromPoint(event.originalEvent.clientX, event.originalEvent.clientY))

  if currentElement.closest(".dropdown-menu").length is 0 and currentElement.closest(".dropdown").length is 0
    hideDropdown event.currentTarget

  return true

$(document).on window.WILLStyle.Settings.pageChangeEvent, (event) ->

  # Hold Dropdowns On Click

  $(".dropdown-toggle").on "click", (event) ->
    highlightDropdown(event.currentTarget, true)

    event.stopImmediatePropagation()
    event.stopPropagation()
    return false

  # Highlight Active Dropdowns on Page Change

  $(".dropdown-item.active").each ->
    dropdownMenu = $(this).closest(".dropdown-menu")

    if dropdownMenu
      dropdownLabel = dropdownMenu.attr("aria-labelledby")

      if dropdownLabel
        dropdownTarget = $("##{dropdownLabel}")

        if dropdownTarget
          dropdownTarget.addClass("active")
