(function() {
  'use strict';

  //----------------------------------------------------------------------------------------------
  // This class will add before, after and active classes to elements with an animating property -
  //----------------------------------------------------------------------------------------------

  //---------------------
  // Private Constants  -
  //---------------------

  const _animatedElementSelector = "[animated]";
  const _staticAnimatedElementSelector = "[animated-static]";
  const _frameRate = 1000 / 60;

  const _maximumAnimationDuration = 800;

  //---------------------
  // Private Properties -
  //---------------------

  let _lastScrollTop = -1;
  let _lastWindowHeight = -1;
  let _lastWindowWidth = -1;

  let _updateTimer = undefined;
  let _isUpdating = false;
  let _requiresUpdate = false;

  let _resetTimer = undefined;

  let _cachedScrollTop = -1;
  let _cachedWindowHeight = -1;

  let _heightCache = {};
  let _targetCache = {};

  let _cssInitialized = true;

  //---------------------
  // Private Methods    -
  //---------------------

  function _generateID() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      const r = Math.random() * 16 | 0;
      const v = c === 'x' ? r : (r & 0x3 | 0x8);
      return v.toString(16);
    });
  }

  function _getTargetForElement(element) {
    // Pull element from target cache if it's there
    const animateId = element.getAttribute("animate-id");
    if (animateId && _targetCache[animateId]) {
      return _targetCache[animateId];
    }

    const animatedTarget = element.getAttribute("animated-target");
    if (!animatedTarget) {
      return undefined;
    }

    // If target is inside the element, return it
    const foundInside = element.querySelector(animatedTarget);
    if (foundInside) {
      if (animateId) {
        _targetCache[animateId] = foundInside;
      }
      return foundInside;
    }

    // Loop through parents to find target
    let current = element.parentElement;
    while (current && current !== document.body) {
      if (current.matches && current.matches(animatedTarget)) {
        if (animateId) {
          _targetCache[animateId] = current;
        }
        return current;
      }
      current = current.parentElement;
    }

    // Loop through parents' siblings to find target
    let parent = element.parentElement;
    let iterations = 0;

    while (parent && iterations++ < 100) {
      const targets = parent.querySelectorAll(animatedTarget);

      if (targets.length > 0) {
        const target = targets[0];
        if (animateId) {
          _targetCache[animateId] = target;
        }
        return target;
      }

      parent = parent.parentElement;
    }

    return undefined;
  }

  function _updateAnimatedElements() {
    if (_cssInitialized === false) {
      return;
    }

    if (_isUpdating === true) {
      _requiresUpdate = true;
      return;
    }

    if (_cachedScrollTop === -1) {
      _cachedScrollTop = window.pageYOffset || document.documentElement.scrollTop;
    }

    if (_cachedWindowHeight === -1) {
      _cachedWindowHeight = window.outerHeight;
    }

    _requiresUpdate = false;
    _isUpdating = true;

    const windowHeight = _cachedWindowHeight;

    const windowTop = _cachedScrollTop;
    const windowCenter = windowHeight / 2 + windowTop;
    const windowBottom = windowHeight + windowTop;

    let _hasReset = false;

    const elements = document.querySelectorAll(_animatedElementSelector);
    for (let i = 0; i < elements.length; i++) {
      const element = elements[i];

      // Do each calculation asynchronously to prevent lag
      setTimeout(function() {
        let targetTop = -1;
        let targetHeight = -1;

        let target = element;

        // Set animation ids for cache reference
        if (!element.getAttribute("animate-id")) {
          element.setAttribute("animate-id", _generateID());
        }

        // If we're using another element for targeting, use it
        if (element.getAttribute("animated-target")) {
          const potentialTarget = _getTargetForElement(element);
          if (potentialTarget) {
            target = potentialTarget;
          }

          if (!target.getAttribute("animate-id")) {
            target.setAttribute("animate-id", _generateID());
          }
        }

        const targetAnimateId = target.getAttribute("animate-id");
        if (targetAnimateId && _heightCache[targetAnimateId]) {
          targetTop = _heightCache[targetAnimateId].top;
          targetHeight = _heightCache[targetAnimateId].height;
        }

        if (targetTop < 1) {
          const rect = target.getBoundingClientRect();
          targetTop = rect.top + window.pageYOffset;
          targetHeight = target.offsetHeight;

          if (targetAnimateId) {
            _heightCache[targetAnimateId] = {
              top: targetTop,
              height: targetHeight
            };
          }
        }

        // Remove scroll top if element is data-animation-fixed
        if (element.getAttribute("animated-fixed")) {
          targetTop -= windowTop;
        }

        let isActive = false;

        let beginHeight = targetHeight * 0.1;
        if (beginHeight > 15) {
          beginHeight = 15;
        }

        // Element is fully visible
        if (targetTop + targetHeight < windowTop + windowHeight) {
          isActive = true;
        }
        // Element is at top and we're only using the top as a trigger
        else if (element.getAttribute("animated-begin") && (targetTop + beginHeight) < windowTop + windowHeight) {
          isActive = true;
        }
        // Element is just past the top and we're only using the top as a trigger
        else if (element.getAttribute("animated-visible") && targetTop + (targetHeight * 0.2) < windowTop + windowHeight) {
          isActive = true;
        }

        if (isActive) {
          // Element animation determines the position of future elements, so it requires a remeasure
          if (element.getAttribute("animated-active") !== "true" && element.getAttribute("animated-reset") && _hasReset === false) {
            _hasReset = true;

            if (_resetTimer) {
              clearTimeout(_resetTimer);
            }

            _resetTimer = setTimeout(function() {
              _resetAnimationCache();

              _requiresUpdate = false;
              _isUpdating = false;

              _scheduleAnimatedElementsUpdate();
            }, parseInt(element.getAttribute("animated-reset")) || _maximumAnimationDuration);

          }
          element.setAttribute("animated-active", "true");
        } else if (element.getAttribute("animated-hidden-before")) {
          element.removeAttribute("animated-active");
        }

        // Element is completely off the screen
        if (targetTop + targetHeight < windowTop) {
          element.setAttribute("animated-after", "true");
        } else {
          element.removeAttribute("animated-after");
        }

        // Set progressive classes if element is asking for it
        if (element.getAttribute("animated-progressive")) {
          const targetBottom = targetTop + targetHeight;

          let progressivePosition = 0;

          let totalDistance = windowHeight + targetHeight;
          let traveledDistance = targetBottom - windowTop;

          if (element.getAttribute("animated-begin")) {
            totalDistance = windowHeight;
            traveledDistance = targetTop - windowTop;
          }

          progressivePosition = Math.floor((totalDistance - traveledDistance) / totalDistance * 100);

          if (progressivePosition < 0) {
            progressivePosition = 0;
          }
          if (progressivePosition > 100) {
            progressivePosition = 100;
          }

          if (progressivePosition > 0) {
            element.setAttribute("animated-progressive-position", progressivePosition);
          } else {
            element.removeAttribute("animated-progressive-position");
          }
        }
      }, 0);
    }

    if (_updateTimer) {
      clearTimeout(_updateTimer);
    }

    _updateTimer = setTimeout(function() {
      _isUpdating = false;
      if (_requiresUpdate === true) {
        _scheduleAnimatedElementsUpdate();
      }
    }, _frameRate);
  }

  function _scheduleAnimatedElementsUpdate() {
    if (_isUpdating === true) {
      _requiresUpdate = true;
      return;
    }

    if (window.requestAnimationFrame) {
      window.requestAnimationFrame(_updateAnimatedElements);
    } else {
      _updateAnimatedElements();
    }
  }

  function _resetAnimationCache() {
    _heightCache = {};
    _targetCache = {};

    _cachedScrollTop = -1;
    _cachedWindowHeight = -1;
  }

  //---------------------
  // Observers          -
  //---------------------

  window.addEventListener("scroll", function() {
    const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
    if (scrollTop !== _lastScrollTop) {
      _cachedScrollTop = -1;
      _scheduleAnimatedElementsUpdate();
    }
  });

  window.addEventListener("resize", function() {
    const windowHeight = window.outerHeight;
    const windowWidth = window.outerWidth;
    if (windowHeight !== _lastWindowHeight || windowWidth !== _lastWindowWidth) {
      _lastWindowHeight = windowHeight;
      _lastWindowWidth = windowWidth;

      _resetAnimationCache();
      _scheduleAnimatedElementsUpdate();
    }
  });

  document.addEventListener(window.WILLStyle.Settings.pageChangeEvent, function(event) {
    _resetAnimationCache();
    _scheduleAnimatedElementsUpdate();
  });

  // Force animated element update on page change
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function() {
      _resetAnimationCache();
      _scheduleAnimatedElementsUpdate();
    });
  } else {
    _resetAnimationCache();
    _scheduleAnimatedElementsUpdate();
  }

  document.addEventListener('turbo:before-render', function(event) {
    const elements = document.querySelectorAll(_staticAnimatedElementSelector);
    for (let i = 0; i < elements.length; i++) {
      const element = elements[i];
      const id = element.getAttribute("id");

      if (element.getAttribute("animated-active") && id !== "") {
        if (event.detail && event.detail.newBody) {
          const newBody = event.detail.newBody;
          const targetElement = newBody.querySelector ? newBody.querySelector(`#${id}`) : null;
          if (targetElement) {
            targetElement.setAttribute("animated-active", "true");
            targetElement.setAttribute("animated-active-init", "true");
          }
        }
      }
    }
  });

  window.WILLStyle.Events.on("update-animated-elements", function() {
    _scheduleAnimatedElementsUpdate();
  });

  window.WILLStyle.Events.on("reset-animated-elements", function() {
    _resetAnimationCache();
    _scheduleAnimatedElementsUpdate();
  });

  window.WILLStyle.Events.on("css-initialized", function() {
    _cssInitialized = true;

    _resetAnimationCache();
    _scheduleAnimatedElementsUpdate();
  });

  window.WILLStyle.Events.on("image-loaded", function(image) {
    if (image && image.nodeType === 1) {
      const computedStyle = window.getComputedStyle(image);
      const position = computedStyle.position;
      if (position === "static" || position === "relative") {
        _resetAnimationCache();
      }
    }
  });

  //---------------------
  // Initialization     -
  //---------------------

  if (window.WILLStyle.Settings.synchronousCSS === false) {
    _cssInitialized = false;
  }
})();
