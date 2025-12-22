(function() {
  'use strict';

  //
  // Set Loading and Loaded properties for images and image backgrounds
  //

  const imageLoadingQuery = ".image-bg:not(.loaded), .image-bg-display:not(.loaded), img:not(.loaded)";

  const loadedImages = {};

  let imagePollInterval = undefined;

  // Get the source of an image or css background-image
  function getImageSourceForElement(element) {
    let source = "";

    if (element.tagName === "IMG") {
      if (!element.getAttribute("srcset")) {
        if (element.getAttribute("data-src")) {
          element.setAttribute("src", element.getAttribute("data-src"));
        }
        source = element.getAttribute("src") || "";
      }
    } else {
      const computedStyle = window.getComputedStyle(element);
      const bg = computedStyle.backgroundImage;

      if (bg.indexOf("url") !== -1) {
        const matches = bg.match(/url\(.*?\)/gi);

        if (matches && matches.length > 0) {
          source = matches[matches.length - 1].replace('url(', '').replace(')', '').replace(/[\"\']/gi, "");
        }
      }
    }

    // Ensure source is empty string for logic checking
    if (!source) {
      source = "";
    }

    return source;
  }

  // Preset loading state if image has already been loaded
  function presetImageLoading(images) {
    for (let i = 0; i < images.length; i++) {
      const element = images[i];

      const source = getImageSourceForElement(element);

      if (element.classList.contains("loaded") || loadedImages.hasOwnProperty(source)) {
        element.classList.add("loaded");
      }
    }
  }

  // Setup loading / loaded statuses for all images
  function setUpImageLoading() {
    const elements = document.querySelectorAll(imageLoadingQuery);
    for (let i = 0; i < elements.length; i++) {
      const element = elements[i];
      let imageElement = false;

      const source = getImageSourceForElement(element);

      if (element.classList.contains("loaded") || loadedImages.hasOwnProperty(source)) {
        element.classList.add("loaded");
        element.removeAttribute("data-image-loading-checking");
      } else if (source === "" && !element.getAttribute("data-src")) {
        if (element.getAttribute("srcset")) {
          imageElement = element;
        } else {
          element.classList.add("loaded");
          element.removeAttribute("data-image-loading-checking");
        }
      } else if (element.getAttribute("data-image-loading-checking")) {
        // Don't scan
      } else {
        element.setAttribute("data-image-loading-checking", "true");

        element.classList.add("loading");
        imageElement = new Image();
        imageElement.src = source;
      }

      if (imageElement) {
        if (imageElement.complete) {
          element.classList.remove("loading");
          element.classList.add("loaded");
          element.removeAttribute("data-image-loading-checking");
          window.WillStyle.Events.trigger("image-loaded", element);
        } else {
          imageElement.onload = function() {
            loadedImages[source] = "";

            element.classList.remove("loading");
            element.classList.add("loaded");
            element.removeAttribute("data-image-loading-checking");

            if (!imageElement.complete || imageElement.naturalHeight === 0) {
              element.classList.add("error");
            }

            window.WillStyle.Events.trigger("image-loaded", element);
          };

          imageElement.onerror = function() {
            setTimeout(function() {
              element.classList.remove("loading");
              element.classList.add("loaded");
              element.classList.add("error");
            }, 1000);
          };
        }
      }
    }
  }

  // Update image loading on turbo load
  document.addEventListener(window.WillStyle.Settings.pageChangeEvent, function() {
    // Delay checking image backgrounds to make sure we catch added via javascript
    setTimeout(function() {
      setUpImageLoading();
    }, 1);
  });

  // Pre-process image loading when we revisit pages in turbo
  document.addEventListener('turbo:before-render', function(event) {
    if (event.detail && event.detail.newBody) {
      const newBody = event.detail.newBody;
      const images = newBody.querySelectorAll ? newBody.querySelectorAll(imageLoadingQuery) : [];
      presetImageLoading(Array.from(images));
    }
  });

  // Set up image poll interval to automatically check for images
  imagePollInterval = setInterval(function() {
    setUpImageLoading();
  }, 500);
})();
