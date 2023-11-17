#
# Adding hover functionality to the bootstrap dropdowns
#

currentDropdown = undefined

getDropdown = (dropdownToggle) ->
  return unless dropdownToggle

  if dropdownToggle.closest(".dropdown")
    return dropdownToggle.closest(".dropdown")
  else if dropdownToggle.closest(".dropdown-menu[aria-labelledby]")
    return dropdownToggle.closest(".dropdown-menu[aria-labelledby]").closest(".dropdown")

getDropdownMenu = (dropdown) ->
  return unless dropdown

  if dropdown.querySelector(".dropdown-menu").length > 0 and !dropdown.querySelector(".dropdown-menu").classList.contains("dropdown-small")
    return dropdown.querySelector(".dropdown-menu")
  else
    return document.querySelector(".dropdown-menu[aria-labelledby='#{dropdown.querySelector(".dropdown-toggle").getAttribute("id")}']")

highlightDropdown = (dropdownToggle, permanently = false) ->
  dropdown = getDropdown(dropdownToggle)

  return unless dropdown

  if currentDropdown and currentDropdown isnt dropdown
    currentDropdown = undefined

  # Clear all other dropdowns
  for element in document.querySelectorAll(".dropdown, .dropdown-menu")
    element.classList.remove("show")

  for element in document.querySelectorAll(".dropdown-toggle")
    element.classList.remove("active")

  dropdown.classList.add("show")
  getDropdownMenu(dropdown).classList.add("show") if getDropdownMenu(dropdown)

  if permanently is true
    currentDropdown = dropdown

hideDropdown = (dropdownToggle) ->
  dropdown = getDropdown(dropdownToggle)

  return unless dropdown
  return if currentDropdown

  dropdownToggle.blur()

  currentDropdown = undefined

  dropdown.classList.remove("show")
  getDropdownMenu(dropdown).classList.remove("show") if getDropdownMenu(dropdown)

clearAnimationClasses = (dropdownToggle) ->
  dropdown = getDropdown(dropdownToggle)

  return unless dropdown

  dropdownMenu = getDropdownMenu(dropdown)

  dropdownToggle.classList.remove("no-anim")
  dropdownMenu.classList.remove("no-anim")

onDropdownEnter = (event) ->
  return unless event.target.classList.contains("dropdown-toggle")

  clearAnimationClasses(event.target)

  highlightDropdown event.target
  return true

onDropdownOut = (event) ->
  return unless event and event.clientX and event.clientY

  currentElement = document.elementFromPoint(event.clientX, event.clientY)

  unless !currentElement or currentElement.closest(".dropdown-menu, .dropdown")
    hideDropdown event.target

  return true

onDropdownClick = (event) ->
  highlightDropdown(event.target, true)

  event.stopImmediatePropagation()
  event.stopPropagation()
  return false

document.addEventListener window.WILLStyle.Settings.pageChangeEvent, (event) ->
  # Setup event listeners
  for element in document.querySelectorAll(".dropdown-toggle, .dropdown-menu")
    element.addEventListener "click", onDropdownClick

    element.addEventListener "mouseover", onDropdownEnter
    element.addEventListener "focusin", onDropdownEnter

    element.addEventListener "mouseout", onDropdownOut
    element.addEventListener "focusout", onDropdownOut

  # Highlight Active Dropdowns on Page Change
  for element in document.querySelectorAll(".dropdown-item.active")
    dropdownMenu = element.closest(".dropdown-menu")

    if dropdownMenu
      dropdownLabel = dropdownMenu.getAttribute("aria-labelledby")

      if dropdownLabel
        dropdownTarget = document.querySelector("##{dropdownLabel}")

        if dropdownTarget
          dropdownTarget.classList.add("active")
