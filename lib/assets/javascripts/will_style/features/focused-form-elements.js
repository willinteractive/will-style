(function() {
  'use strict';

  document.addEventListener("focus", function(event) {
    const target = event.target;
    if (target.matches("input, textarea")) {
      const container = target.closest(".form-container");
      if (container) {
        container.classList.add("focus");
      }
    }
  }, true);

  document.addEventListener("blur", function(event) {
    const target = event.target;
    if (target.matches("input, textarea")) {
      const container = target.closest(".form-container");
      if (container) {
        container.classList.remove("focus");
      }
    }
  }, true);

  document.addEventListener("mouseenter", function(event) {
    const target = event.target;
    if (target.matches("input, button")) {
      const container = target.closest(".button-container");
      if (container) {
        container.classList.add("hover");
      }
    }
  }, true);

  document.addEventListener("mouseleave", function(event) {
    const target = event.target;
    if (target.matches("input, button")) {
      const container = target.closest(".button-container");
      if (container) {
        container.classList.remove("hover");
      }
    }
  }, true);

  function handleInputChange(event) {
    const target = event.target;
    if (target.matches("input, textarea")) {
      const container = target.closest(".form-container");
      if (container) {
        if (target.value === "") {
          container.classList.remove("entered");
        } else {
          container.classList.add("entered");
        }
      }
    }
  }

  document.addEventListener("keyup", handleInputChange, true);
  document.addEventListener("keydown", handleInputChange, true);
  document.addEventListener("change", handleInputChange, true);
  document.addEventListener("blur", handleInputChange, true);

  document.addEventListener("change", function(event) {
    const target = event.target;
    if (target.matches("select")) {
      const selectionTriggered = target.getAttribute("data-selection-triggered");
      const container = target.closest(".form-container");
      if (selectionTriggered && container) {
        container.classList.add("entered");
      } else {
        target.setAttribute("data-selection-triggered", "true");
      }
    }
  }, true);

  function handleSelectMouse(event) {
    const target = event.target;
    if (target.matches("select")) {
      const container = target.closest(".form-container");
      if (container) {
        target.setAttribute("data-selection-triggered", "true");
        container.classList.add("entered");
      }
    }
  }

  document.addEventListener("mousedown", handleSelectMouse, true);
  document.addEventListener("mouseup", handleSelectMouse, true);

  document.addEventListener(window.WILLStyle.Settings.pageChangeEvent, function() {
    // Set a timeout to let other JS run that might set values
    setTimeout(function() {
      const selects = document.querySelectorAll("select");
      for (let i = 0; i < selects.length; i++) {
        const select = selects[i];
        const selectedOption = select.options[select.selectedIndex];
        if (selectedOption && selectedOption.text !== "" && select.closest(".form-container")) {
          select.setAttribute("data-selection-triggered", "true");
          const container = select.closest(".form-container");
          if (container) {
            container.classList.add("entered");
          }
        }
      }

      const inputs = document.querySelectorAll("input, textarea");
      for (let i = 0; i < inputs.length; i++) {
        const input = inputs[i];
        if (input.value !== "" && input.closest(".form-container")) {
          const container = input.closest(".form-container");
          if (container) {
            container.classList.add("entered");
          }
        }
      }
    }, 10);
  });
})();
