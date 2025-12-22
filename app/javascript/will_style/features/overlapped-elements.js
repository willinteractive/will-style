(function() {
  'use strict';

  //----------------------------------------------------------------------------------------------
  // This class will add negative 50% height margins to elements with overlap props              -
  //----------------------------------------------------------------------------------------------

  //---------------------
  // Private Constants  -
  //---------------------

  const _elementSelector = "[overlap]";
  const _parentSelector = "[overlap-parent]";
  const _afterSelector = "[overlap-after]";
  const _frameRate = 1000 / 60;

  const _maximumAnimationDuration = 800;

  //---------------------
  // Private Properties -
  //---------------------

  let _lastWindowHeight = -1;
  let _lastWindowWidth = -1;

  let _updateTimer = undefined;
  let _isUpdating = false;
  let _requiresUpdate = false;

  let _resetTimer = undefined;

  function _updateOverlappedElements() {
    if (_isUpdating === true) {
      _requiresUpdate = true;
      return;
    }

    _requiresUpdate = false;
    _isUpdating = true;

    const elements = document.querySelectorAll(_elementSelector);
    for (let i = 0; i < elements.length; i++) {
      const element = elements[i];

      // Do each calculation asynchronously to prevent lag
      setTimeout(function() {
        element.style.transform = "translateY(-50%)";

        const parent = element.closest(_parentSelector);
        if (parent) {
          parent.style.marginTop = `${element.offsetHeight / 2}px`;
          parent.setAttribute("overlap-active", "true");
        }

        const afterElements = element.parentElement.querySelectorAll(_afterSelector);
        for (let j = 0; j < afterElements.length; j++) {
          afterElements[j].style.marginTop = `-${element.offsetHeight / 2}px`;
        }
      }, 0);
    }

    if (_updateTimer) {
      clearTimeout(_updateTimer);
    }

    _updateTimer = setTimeout(function() {
      _isUpdating = false;
      if (_requiresUpdate === true) {
        _scheduleOverlappedElementsUpdate();
      }
    }, _frameRate);
  }

  function _scheduleOverlappedElementsUpdate() {
    if (_isUpdating === true) {
      _requiresUpdate = true;
      return;
    }

    if (window.requestAnimationFrame) {
      window.requestAnimationFrame(_updateOverlappedElements);
    } else {
      _updateOverlappedElements();
    }
  }

  //---------------------
  // Observers          -
  //---------------------

  window.addEventListener("resize", function() {
    const windowHeight = window.outerHeight;
    const windowWidth = window.outerWidth;
    if (windowHeight !== _lastWindowHeight || windowWidth !== _lastWindowWidth) {
      _lastWindowHeight = windowHeight;
      _lastWindowWidth = windowWidth;

      _scheduleOverlappedElementsUpdate();
    }
  });

  window.WillStyle.Events.on("css-initialized", function() {
    _scheduleOverlappedElementsUpdate();
  });

  window.WillStyle.Events.on("image-loaded", function(image) {
    if (image && image.nodeType === 1) {
      const computedStyle = window.getComputedStyle(image);
      const position = computedStyle.position;
      if (position === "static" || position === "relative") {
        _scheduleOverlappedElementsUpdate();
      }
    }
  });

  document.addEventListener(window.WillStyle.Settings.pageChangeEvent, function(event) {
    _updateOverlappedElements();
  });

  // Force element update on page change
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function() {
      _updateOverlappedElements();
    });
  } else {
    _updateOverlappedElements();
  }
})();
