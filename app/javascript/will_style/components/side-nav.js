// Opens and closes the side nav (components/_side-nav.scss) as a panel below
// the lg breakpoint. From lg up it's a column and these never fire, since
// the toggle and close buttons are hidden there.
//
// [data-side-nav-toggle] opens the nav its aria-controls names;
// [data-side-nav-close] (the panel's close button, the backdrop) closes it,
// as does Escape. Focus moves into the panel on open and back to the toggle
// on close. Plain DOM rather than Bootstrap's offcanvas, which this gem
// doesn't depend on.
import { Settings } from "will_style/core/settings";

let lastToggle = null;

function openNav(nav, toggle) {
  lastToggle = toggle;
  nav.classList.add("open");
  document.body.classList.add("side-nav-open");
  document.querySelectorAll(`[data-side-nav-toggle][aria-controls="${nav.id}"]`).forEach(function(button) {
    button.setAttribute("aria-expanded", "true");
  });

  const focusable = nav.querySelector("[data-side-nav-close], a, button");
  if (focusable) {
    focusable.focus();
  }
}

function closeNav(nav) {
  nav.classList.remove("open");
  document.body.classList.remove("side-nav-open");
  document.querySelectorAll(`[data-side-nav-toggle][aria-controls="${nav.id}"]`).forEach(function(button) {
    button.setAttribute("aria-expanded", "false");
  });

  if (lastToggle && document.contains(lastToggle)) {
    lastToggle.focus();
  }
  lastToggle = null;
}

document.addEventListener("click", function(event) {
  const toggle = event.target.closest("[data-side-nav-toggle]");
  if (toggle) {
    const nav = document.getElementById(toggle.getAttribute("aria-controls"));
    if (nav) {
      event.preventDefault();
      if (nav.classList.contains("open")) {
        closeNav(nav);
      } else {
        openNav(nav, toggle);
      }
    }
    return;
  }

  const close = event.target.closest("[data-side-nav-close]");
  if (close) {
    const nav = document.getElementById(close.getAttribute("aria-controls")) || document.querySelector(".side-nav.open");
    if (nav) {
      event.preventDefault();
      closeNav(nav);
    }
  }
});

document.addEventListener("keydown", function(event) {
  if (event.key === "Escape") {
    const nav = document.querySelector(".side-nav.open");
    if (nav) {
      closeNav(nav);
    }
  }
});

// A Turbo visit swaps the body; start each page with the panel closed.
document.addEventListener(Settings.pageChangeEvent, function() {
  document.body.classList.remove("side-nav-open");
  lastToggle = null;
});
