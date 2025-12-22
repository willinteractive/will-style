//
// Adding hover functionality to the bootstrap dropdowns
//
(function() {
  'use strict';

  let currentDropdown = undefined;

  function getDropdown(dropdownToggle) {
    if (!dropdownToggle) {
      return;
    }

    if (dropdownToggle.closest(".dropdown")) {
      return dropdownToggle.closest(".dropdown");
    } else if (dropdownToggle.closest(".dropdown-menu[aria-labelledby]")) {
      return dropdownToggle.closest(".dropdown-menu[aria-labelledby]").closest(".dropdown");
    }
  }

  function getDropdownMenu(dropdown) {
    if (!dropdown) {
      return;
    }

    const menu = dropdown.querySelector(".dropdown-menu");
    if (menu && !menu.classList.contains("dropdown-small")) {
      return menu;
    } else {
      return document.querySelector(`.dropdown-menu[aria-labelledby='${dropdown.querySelector(".dropdown-toggle").getAttribute("id")}']`);
    }
  }

  function highlightDropdown(dropdownToggle, permanently = false) {
    const dropdown = getDropdown(dropdownToggle);

    if (!dropdown) {
      return;
    }

    if (currentDropdown && currentDropdown !== dropdown) {
      currentDropdown = undefined;
    }

    // Clear all other dropdowns
    const allDropdowns = document.querySelectorAll(".dropdown, .dropdown-menu");
    for (let i = 0; i < allDropdowns.length; i++) {
      allDropdowns[i].classList.remove("show");
    }

    const allToggles = document.querySelectorAll(".dropdown-toggle");
    for (let i = 0; i < allToggles.length; i++) {
      allToggles[i].classList.remove("active");
    }

    dropdown.classList.add("show");
    const menu = getDropdownMenu(dropdown);
    if (menu) {
      menu.classList.add("show");
    }

    if (permanently === true) {
      currentDropdown = dropdown;
    }
  }

  function hideDropdown(dropdownToggle) {
    const dropdown = getDropdown(dropdownToggle);

    if (!dropdown) {
      return;
    }
    if (currentDropdown) {
      return;
    }

    dropdownToggle.blur();

    currentDropdown = undefined;

    dropdown.classList.remove("show");
    const menu = getDropdownMenu(dropdown);
    if (menu) {
      menu.classList.remove("show");
    }
  }

  function clearAnimationClasses(dropdownToggle) {
    const dropdown = getDropdown(dropdownToggle);

    if (!dropdown) {
      return;
    }

    const dropdownMenu = getDropdownMenu(dropdown);

    dropdownToggle.classList.remove("no-anim");
    dropdownMenu.classList.remove("no-anim");
  }

  function onDropdownEnter(event) {
    if (!event.target.classList.contains("dropdown-toggle")) {
      return true;
    }

    clearAnimationClasses(event.target);

    highlightDropdown(event.target);
    return true;
  }

  function onDropdownOut(event) {
    if (!event || !event.clientX || !event.clientY) {
      return true;
    }

    const currentElement = document.elementFromPoint(event.clientX, event.clientY);

    if (currentElement && !currentElement.closest(".dropdown-menu, .dropdown")) {
      hideDropdown(event.target);
    }

    return true;
  }

  function onDropdownClick(event) {
    highlightDropdown(event.target, true);

    event.stopImmediatePropagation();
    event.stopPropagation();
    return false;
  }

  document.addEventListener(window.WillStyle.Settings.pageChangeEvent, function() {
    // Setup event listeners
    const elements = document.querySelectorAll(".dropdown-toggle, .dropdown-menu");

    for (let i = 0; i < elements.length; i++) {
      const element = elements[i];
      element.addEventListener("click", onDropdownClick);

      element.addEventListener("mouseover", onDropdownEnter);
      element.addEventListener("focusin", onDropdownEnter);

      element.addEventListener("mouseout", onDropdownOut);
      element.addEventListener("focusout", onDropdownOut);
    }

    // Highlight Active Dropdowns on Page Change
    const activeItems = document.querySelectorAll(".dropdown-item.active");
    for (let i = 0; i < activeItems.length; i++) {
      const element = activeItems[i];
      const dropdownMenu = element.closest(".dropdown-menu");

      if (dropdownMenu) {
        const dropdownLabel = dropdownMenu.getAttribute("aria-labelledby");

        if (dropdownLabel) {
          const dropdownTarget = document.querySelector(`#${dropdownLabel}`);

          if (dropdownTarget) {
            dropdownTarget.classList.add("active");
          }
        }
      }
    }
  });
})();
