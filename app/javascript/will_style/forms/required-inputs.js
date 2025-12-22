(function() {
  'use strict';

  let isEmail = function(value) {
    var email_regex = new RegExp(/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i);
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
