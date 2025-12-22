(function() {
  'use strict';

  document.addEventListener("click", function(event) {
    const target = event.target;
    if (target.matches(".blocked-button input") || target.closest(".blocked-button input")) {
      const input = target.matches("input") ? target : target.closest("input");
      if (input) {
        input.classList.add("selected");
      }
    }
  }, true);
})();
