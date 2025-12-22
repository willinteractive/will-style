(function() {
  'use strict';

  //-------------------------------
  // Full Frame Video Backgrounds -
  //-------------------------------

  //---------------------
  // Private Constants  -
  //---------------------

  const _frameRate = 1000 / 24;

  //---------------------
  // Private Properties -
  //---------------------

  let _lastScrollTop = -1;
  let _lastWindowHeight = -1;
  let _lastWindowWidth = -1;

  let _updateTimer = undefined;
  let _isUpdating = false;
  let _requiresUpdate = false;

  function _getAspectRatio(video) {
    if (video.videoWidth > 0 && video.currentTime > 0) {
      return video.videoHeight / video.videoWidth;
    }

    return 0;
  }

  function _initializeVideoElement(video) {
    if (_getAspectRatio(video) !== 0) {
      const videoBg = video.closest(".video-bg");
      if (videoBg) {
        videoBg.classList.add("loaded");
      }
      _resizeVideoElement(video);
    }
  }

  function _initializeVideoElements() {
    const videos = document.querySelectorAll("video");
    for (let i = 0; i < videos.length; i++) {
      _initializeVideoElement(videos[i]);
    }
  }

  function _resizeVideoElement(video) {
    let windowWidth, windowHeight;
    const videoBg = video.closest(".video-bg");
    if (videoBg) {
      windowWidth = videoBg.offsetWidth;
      windowHeight = videoBg.offsetHeight;
    } else {
      windowWidth = window.innerWidth;
      windowHeight = window.innerHeight;
    }

    // If we're not visible, revisit in 100ms
    if (windowWidth === 0 && windowHeight === 0) {
      setTimeout(function() {
        _resizeVideoElement(video);
      }, 100);
    } else {
      const windowAspectRatio = windowHeight / windowWidth;
      const elementAspectRatio = _getAspectRatio(video);

      if (elementAspectRatio === 0) {
        return;
      }

      if (windowAspectRatio <= elementAspectRatio) {
        const newHeight = windowWidth * elementAspectRatio;

        video.style.width = windowWidth + "px";
        video.style.height = newHeight + "px";
        video.style.top = (windowHeight - newHeight) / 2 + "px";
        video.style.left = "0px";
      } else {
        const newWidth = windowHeight / elementAspectRatio;

        video.style.width = newWidth + "px";
        video.style.height = windowHeight + "px";
        video.style.top = "0px";
        video.style.left = (windowWidth - newWidth) / 2 + "px";
      }

      setTimeout(function() {
        const videoBg = video.closest(".video-bg");
        if (videoBg) {
          videoBg.classList.add("active");
        }
      }, 100);
    }
  }

  function _resizeVideoElements() {
    const videos = document.querySelectorAll("video");
    for (let i = 0; i < videos.length; i++) {
      _resizeVideoElement(videos[i]);
    }
  }

  function _scheduleResizeVideoElements() {
    if (_isUpdating === true) {
      _requiresUpdate = true;
      return;
    }

    _isUpdating = true;

    _updateTimer = setTimeout(function() {
      _isUpdating = false;

      if (_requiresUpdate === true) {
        _requiresUpdate = false;
        _scheduleResizeVideoElements();
      }
    }, _frameRate);

    if (window.requestAnimationFrame) {
      window.requestAnimationFrame(_resizeVideoElements);
    } else {
      _resizeVideoElements();
    }
  }

  document.addEventListener(window.WillStyle.Settings.pageChangeEvent, function() {
    _initializeVideoElements();

    const videos = document.querySelectorAll("video");
    for (let i = 0; i < videos.length; i++) {
      const video = videos[i];
      video.addEventListener("loadedmetadata", function(event) {
        _initializeVideoElement(event.target);
      });
      video.addEventListener("timeupdate", function(event) {
        _initializeVideoElement(event.target);
      });
    }
  });

  window.addEventListener("resize", function() {
    const windowHeight = window.outerHeight;
    const windowWidth = window.outerWidth;
    if (windowHeight !== _lastWindowHeight || windowWidth !== _lastWindowWidth) {
      _lastWindowHeight = windowHeight;
      _lastWindowWidth = windowWidth;

      _scheduleResizeVideoElements();
    }
  });
})();
