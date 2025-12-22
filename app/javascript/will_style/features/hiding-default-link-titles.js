(function() {
  'use strict';

  // Remove and Re-Add link titles on links when hovering so we don't get browser pop-in

  document.addEventListener("mouseenter", function(event) {
    const element = event.target.closest("a, button");
    if (element && element.hasAttribute("title")) {
      element.setAttribute("data-hover-title", element.getAttribute("title"));
      element.removeAttribute("title");
    }
  }, true);

  document.addEventListener("mouseleave", function(event) {
    const element = event.target.closest("a, button");
    if (element && element.hasAttribute("data-hover-title")) {
      element.setAttribute("title", element.getAttribute("data-hover-title"));
      element.removeAttribute("data-hover-title");
    }
  }, true);
})();
