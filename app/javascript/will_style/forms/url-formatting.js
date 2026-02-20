(function() {
  'use strict';

  let urlify = function(value, isEditing) {
    if (isEditing === void 0) { isEditing = false; }
    // turn spaces into dashes and convert to lowercase
    value = value.toLowerCase().replace(/\s+/g, "-");

    // Replace all non word characters, dashes, and slashes with nothing
    // and dashes and slashes at the beginning of the name with nothing
    value = value.replace(/[^\w\-\/]/g, "").replace(/^[\-\/]+/g, "");

    // If we're editing, don't replace dashes and slashes at the end, it'd be frustrating
    if (!isEditing) {
      value = value.replace(/[\-\/]+$/g, "");
    }

    // Reduce all multiple dashes and slashes to a single dash
    value = value.replace(/[\-\/]+/g, "-");

    return value;
  };

  document.addEventListener("keyup", function(event) {
    const target = event.target;
    if (target.matches("input[data-type=url]")) {
      const new_value = urlify(target.value, true);
      if (new_value !== target.value) {
        target.value = new_value;
      }
    }
  }, true);

  document.addEventListener("blur", function(event) {
    const target = event.target;
    if (target.matches("input[data-type=url]")) {
      const new_value = urlify(target.value, false);
      if (new_value !== target.value) {
        target.value = new_value;
      }
    }
  }, true);

  document.addEventListener("paste", function(event) {
    const target = event.target;
    if (target.matches("input[data-type=url]")) {
      setTimeout(function() {
        const new_value = urlify(target.value, false);
        if (new_value !== target.value) {
          target.value = new_value;
        }
      }, 0);
    }
  }, true);

  document.addEventListener("change", function(event) {
    const target = event.target;
    if (target.matches("input[data-type=url]")) {
      const new_value = urlify(target.value, false);
      if (new_value !== target.value) {
        target.value = new_value;
      }
    }
  }, true);

  document.addEventListener("submit", function(event) {
    const form = event.target;
    if (form.matches("form")) {
      const urlInputs = form.querySelectorAll("input[data-type=url]");
      for (let i = 0; i < urlInputs.length; i++) {
        urlInputs[i].value = urlify(urlInputs[i].value, false);
      }
    }
  }, true);
})();
