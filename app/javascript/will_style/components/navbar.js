(function() {
  'use strict';

  // Add collapsing out functionality to the navbar on small screens
  document.addEventListener("click", function(event) {
    const button = event.target.closest(".navbar-toggler");
    if (button) {

      if (button.getAttribute("aria-expanded") === "false") {
        const menu = Array.from(button.parentElement.children).find(el => el.classList.contains("navbar-collapse"));
        if (menu) {
          menu.classList.add("collapsing-out");

          let iterationCount = 0;
          const checkInterval = setInterval(function() {
            if (!menu.classList.contains("collapsing") || iterationCount++ > 100) {
              menu.classList.remove("collapsing-out");

              if (checkInterval) {
                clearInterval(checkInterval);
              }
            }
          }, 1000 / 4);
        }
      }
    }
  });

  // Add class on navbar to make sure it's on top of content
  document.addEventListener("click", function(event) {
    const button = event.target.closest(".navbar-toggler");
    if (button) {

      if (button.getAttribute("aria-expanded") === "false") {
        document.body.classList.remove("navbar-active");
      } else {
        document.body.classList.add("navbar-active");
      }
    }
  });

  let _cachedNavHeight = -1;

  function _checkNavbarObscure() {
    const navbar = document.querySelector("nav.navbar.fixed");
    if (navbar) {
      _cachedNavHeight = navbar.offsetHeight;
      let addObscureClass = false;

      if (_cachedNavHeight > 0) {
        addObscureClass = window.scrollY > navbar.offsetHeight;
      }

      if (addObscureClass) {
        navbar.classList.add("obscure");
      } else {
        navbar.classList.remove("obscure");
      }
    }
  }

  // Add class on navbar to make sure it's on top of content
  window.addEventListener("scroll", _checkNavbarObscure);

  window.addEventListener("resize", function(event) {
    _cachedNavHeight = -1;
    _checkNavbarObscure();
  });
})();
