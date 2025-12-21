// Move Bootstrap Modals to the body so they're always on top of the overlay

(function() {
  'use strict';

  document.addEventListener(window.WILLStyle.Settings.pageChangeEvent, function(event) {
    const elements = document.querySelectorAll(".modal");
    for (let i = 0; i < elements.length; i++) {
      document.querySelector("body").append(elements[i]);
    }
  });
})();
