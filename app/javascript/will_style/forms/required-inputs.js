(function() {
  'use strict';

  let isEmail = function(value) {
    var email_regex = new RegExp(/^[^\s@]+@[^\s@]+\.[^\s@]+$/i);
    return email_regex.test(value);
  };

  let update_submit = function(form) {
    let disabled = false;

    const requiredElements = form.querySelectorAll(".required");
    for (let i = 0; i < requiredElements.length; i++) {
      const element = requiredElements[i];
      // Ensure we're in the correct form and it's not a select2 hidden element
      if (element.closest("form") === form) {
        // Don't trigger disabled classes on select2 elements
        const id = element.getAttribute("id");
        if (id && id.indexOf("s2") === 0) {

        } else {
          const value = element.value;
          if (value === null || value === "") {
            disabled = true;
          }

          // Enforce valid email addresses on email fields
          const type = element.getAttribute("type");
          if (type === "email" && isEmail(value) === false) {
            disabled = true;
          }
        }
      }
    }

    const submitButtons = form.querySelectorAll("[type=submit]");
    for (let i = 0; i < submitButtons.length; i++) {
      submitButtons[i].disabled = disabled;
    }

    const requireDependentButtons = form.querySelectorAll("button.require-dependent");
    for (let i = 0; i < requireDependentButtons.length; i++) {
      requireDependentButtons[i].disabled = disabled;
    }

    // Add disabled classes to input containers
    for (let i = 0; i < submitButtons.length; i++) {
      const container = submitButtons[i].closest(".button-container");
      if (container) {
        if (disabled) {
          container.classList.add("disabled");
        } else {
          container.classList.remove("disabled");
        }
      }
    }

    for (let i = 0; i < requireDependentButtons.length; i++) {
      const container = requireDependentButtons[i].closest(".button-container");
      if (container) {
        if (disabled) {
          container.classList.add("disabled");
        } else {
          container.classList.remove("disabled");
        }
      }
    }
  }

  function update_required(element) {
    let label = null;
    // Check siblings
    if (element.parentElement) {
      const siblings = Array.from(element.parentElement.children);
      for (let i = 0; i < siblings.length; i++) {
        if (siblings[i] !== element && siblings[i].classList.contains("required-label")) {
          label = siblings[i];
          break;
        }
      }
    }
    // If not found in siblings, check in closest section
    if (!label) {
      const section = element.closest("section");
      if (section) {
        label = section.querySelector(".required-label");
      }
    }

    // Ensure it's not a select2 hidden element
    const id = element.getAttribute("id");
    if (!(id && id.indexOf("s2") === 0)) {
      let disabled = false;
      const value = element.value;
      if (value === null || value === "") {
        disabled = true;
      }

      // Enforce valid email addresses on email fields
      const type = element.getAttribute("type");
      if (type === "email" && isEmail(value) === false) {
        disabled = true;
      }

      if (label) {
        if (disabled) {
          label.classList.remove("success");
          label.classList.add("alert");
        } else {
          label.classList.add("success");
          label.classList.remove("alert");
        }
      }
    }
  }

  function handleRequiredChange(event) {
    const target = event.target;
    if (target.classList.contains("required")) {
      update_required(target);
      const form = target.closest("form");
      if (form) {
        update_submit(form);
      }
    }
  }

  document.addEventListener("change", handleRequiredChange, true);
  document.addEventListener("keyup", handleRequiredChange, true);
  document.addEventListener("input", handleRequiredChange, true);
  document.addEventListener("paste", function(event) {
    setTimeout(function() {
      handleRequiredChange(event);
    }, 0);
  }, true);

  // Handle propertychange for IE
  if (document.addEventListener) {
    document.addEventListener("propertychange", handleRequiredChange, true);
  }

  document.addEventListener(window.WillStyle.Settings.pageChangeEvent, function() {
    const requiredElements = document.querySelectorAll(".required");
    for (let i = 0; i < requiredElements.length; i++) {
      const event = new Event("change", { bubbles: true });
      requiredElements[i].dispatchEvent(event);
    }
  });
})();
