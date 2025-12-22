(function() {
  'use strict';

  let lastWindowHeight = 0;
  let windowSizeObserver = null;

  const popOutOverlay = document.createElement('div');
  popOutOverlay.className = 'pop-out-overlay';

  // Ensure that only safe URLs are used for pop-out iframes / windows.
  function isSafePopOutUrl(url) {
    if (typeof url !== "string") {
      return false;
    }
    const trimmed = url.trim();
    if (!trimmed) {
      return false;
    }

    // Disallow obvious dangerous schemes such as javascript:, data:, vbscript:
    const lower = trimmed.toLowerCase();
    if (lower.startsWith("javascript:") || lower.startsWith("data:") || lower.startsWith("vbscript:")) {
      return false;
    }

    // Allow only http/https (including protocol-relative URLs that will resolve to http/https)
    try {
      // Handle protocol-relative URLs (e.g. //example.com/path) by prefixing current origin's protocol
      const toParse = lower.startsWith("//") ? window.location.protocol + trimmed : trimmed;
      const parsed = new URL(toParse, window.location.origin);
      if (parsed.protocol === "http:" || parsed.protocol === "https:") {
        return true;
      }
      return false;
    } catch (e) {
      // If URL parsing fails, treat as unsafe
      return false;
    }
  }

  function watchPopOut() {
    lastWindowHeight = 0;
    setInterval(() => {
      const windowHeight = window.innerHeight;

      if (lastWindowHeight !== windowHeight) {
        centerPopOut();
      }

      lastWindowHeight = windowHeight;
    }, 1000 / 4);
  }

  function clearPopOut() {
    if (windowSizeObserver) {
      clearInterval(windowSizeObserver);
      windowSizeObserver = null;
    }

    const popOut = document.querySelector('[data-pop-out=""].enabled');

    if (popOut) {
      const popOutId = popOut.getAttribute("id");
      document.body.classList.remove("pop-out-showing");
      document.body.classList.remove("with-iframe");

      const video = popOut.querySelector("video");
      if (video) {
        video.pause();
        video.removeEventListener("ended", clearPopOut);
      }

      popOut.classList.remove("enabled");
      popOutOverlay.classList.remove("enabled");

      const iframe = popOut.querySelector("iframe");
      if (iframe) {
        if (popOut.getAttribute("data-pop-out-fullscreen") !== "") {
          iframe.removeAttribute("src");
        }
      }

      const relatedElements = document.querySelectorAll(`[data-pop-out-id='${popOutId}']`);
      relatedElements.forEach((el) => {
        el.classList.remove("selected");
        const span = el.querySelector("span");
        if (span) {
          span.classList.remove("selected");
        }
      });

      window.WillStyle.Events.trigger("pop-out-hide", popOutId);
    }
  }

  function centerPopOut() {
    const popOut = document.querySelector('[data-pop-out=""].enabled');

    if (popOut) {
      const popOutHeight = popOut.offsetHeight;
      const windowHeight = window.innerHeight;

      if (popOutHeight > windowHeight + 40 || popOut.classList.contains("full")) {
        popOut.style.top = "0px";
      } else {
        popOut.style.top = (windowHeight - popOutHeight) / 2 + "px";
      }
    }
  }

  document.addEventListener("click", (event) => {
    const link = event.target.closest('[data-pop-out-link=""]');
    if (!link) return;

    if (document.querySelector('[data-pop-out=""].enabled')) {
      return;
    }

    const activeClass = link.getAttribute("data-pop-out-active-class");
    if (activeClass && !link.classList.contains(activeClass)) {
      return;
    }

    const popOutId = link.getAttribute("data-pop-out-id");
    if (popOutId) {
      const popOut = document.getElementById(popOutId);
      if (!popOut) return;

      const popOutUrl = link.getAttribute("data-pop-out-url");
      if (popOutUrl && isSafePopOutUrl(popOutUrl)) {
        if (document.documentElement.classList.contains("touchevents") && popOut.getAttribute("data-pop-out-fullscreen") !== "") {
          window.open(popOutUrl, '_blank');
          return;
        }

        let iframe = popOut.querySelector("iframe");
        if (!iframe) {
          const content = popOut.querySelector(".content");
          if (content) {
            iframe = document.createElement("iframe");
            iframe.setAttribute("allowfullscreen", "");
            content.insertBefore(iframe, content.firstChild);
          }
        }

        if (iframe && popOutUrl !== iframe.getAttribute("src")) {
          iframe.setAttribute("src", popOutUrl);
        }

        document.body.classList.add("with-iframe");
      }

      if (popOut.getAttribute("data-pop-out-fullscreen") !== "") {
        popOutOverlay.setAttribute("data-pop-out-id", popOutId);
        if (!popOutOverlay.parentNode) {
          document.body.appendChild(popOutOverlay);
        }
        if (!popOut.parentNode || popOut.parentNode !== document.body) {
          document.body.appendChild(popOut);
        }
      }

      popOut.classList.add("enabled");
      popOutOverlay.classList.add("enabled");
      centerPopOut();

      document.body.classList.add("pop-out-showing");

      watchPopOut();

      const video = popOut.querySelector("video");
      if (video) {
        video.play();
        video.addEventListener("ended", clearPopOut);
      }

      window.WillStyle.Events.trigger("pop-out-show", popOutId);

      event.stopImmediatePropagation();
      event.stopPropagation();

      return false;
    }
  });

  document.addEventListener("click", (event) => {
    if (event.target.closest('.close-pop-out')) {
      clearPopOut();
    }
  });

  document.addEventListener("turbo:load", clearPopOut);

  // Disable fullscreen for pop outs
  function handleFullscreenChange(event) {
    const element = document.fullscreenElement || document.webkitFullscreenElement || document.mozFullScreenElement || document.msFullscreenElement;

    if (element && element.tagName === "IFRAME" && element.closest("[data-pop-out]")) {
      if (document.exitFullscreen) {
        document.exitFullscreen();
      } else if (document.mozCancelFullScreen) {
        document.mozCancelFullScreen();
      } else if (document.webkitCancelFullScreen) {
        document.webkitCancelFullScreen();
      } else if (document.msExitFullscreen) {
        document.msExitFullscreen();
      }
    }
  }

  document.addEventListener("webkitfullscreenchange", handleFullscreenChange);
  document.addEventListener("mozfullscreenchange", handleFullscreenChange);
  document.addEventListener("fullscreenchange", handleFullscreenChange);
  document.addEventListener("MSFullscreenChange", handleFullscreenChange);
})();
