(function() {
  'use strict';

  function shuffle(array) {
    let i = array.length - 1;

    while (i > 0) {
      const j = Math.floor(Math.random() * (i + 1));
      const temp = array[i];
      array[i] = array[j];
      array[j] = temp;
      i--;
    }
  }

  //------------------------------------------------------------------------------------------
  // Transform images with a data-image-bg to add it using a DOM element                     -
  //------------------------------------------------------------------------------------------

  document.addEventListener(window.WillStyle.Settings.pageChangeEvent, function(event) {
    const elements = document.querySelectorAll("[data-image-bg]");
    for (let i = 0; i < elements.length; i++) {
      const element = elements[i];
      const bgImage = element.getAttribute("data-image-bg");
      const bgElement = document.createElement("div");
      bgElement.className = "image-bg-display";
      bgElement.style.backgroundImage = `url('${bgImage}')`;
      element.insertBefore(bgElement, element.firstChild);
    }
  });

  //------------------------------------------------------------------------------------------
  // Rotating image backgrounds                                                              -
  //------------------------------------------------------------------------------------------

  let rotationIntervals = [];

  document.addEventListener(window.WillStyle.Settings.pageChangeEvent, function(event) {
    for (let i = 0; i < rotationIntervals.length; i++) {
      clearInterval(rotationIntervals[i]);
    }

    rotationIntervals = [];

    const elements = document.querySelectorAll("[data-image-bgs]");
    for (let i = 0; i < elements.length; i++) {
      const element = elements[i];
      try {
        const bgsAttr = element.getAttribute("data-image-bgs");
        const bgs = JSON.parse(bgsAttr.replace(/'/gi, '"'));

        let positions = [];
        try {
          const positionsAttr = element.getAttribute("data-image-bg-positions");
          if (positionsAttr) {
            positions = JSON.parse(positionsAttr.replace(/'/gi, '"'));
          }
        } catch (e) {
          // JSON Parse Error
        }

        if (bgs.length > 0) {
          const randomize = element.getAttribute("data-image-bgs-randomize");
          if (randomize === "" || randomize === "true") {
            shuffle(bgs);
          }

          const fixed = element.getAttribute("data-image-bgs-fixed");
          if (fixed === "" || fixed === "true") {
            element.classList.add("fixed");
          }

          element.classList.add("image-bgs");

          for (let index = 0; index < bgs.length; index++) {
            const bg = bgs[index];
            const bgElement = document.createElement("div");
            bgElement.className = "image-bg-display";
            bgElement.style.backgroundImage = `url('${bg}')`;

            if (positions.length === bgs.length) {
              bgElement.className += ` ${positions[index]}`;
            }

            element.appendChild(bgElement);
          }

          const firstBg = element.querySelector(".image-bg-display");
          if (firstBg) {
            firstBg.classList.add("active");
            firstBg.classList.add("first");
          }

          const interval = setInterval(function() {
            const bgs = element.querySelectorAll(".image-bg-display");
            const activeBg = element.querySelector(".image-bg-display.active");

            let activeIndex = 0;
            if (activeBg) {
              for (let j = 0; j < bgs.length; j++) {
                if (bgs[j] === activeBg) {
                  activeIndex = j + 1;
                  break;
                }
              }
            }

            if (activeIndex > bgs.length - 1) {
              activeIndex = 0;
            }

            for (let j = 0; j < bgs.length; j++) {
              bgs[j].classList.remove("active");
              bgs[j].classList.remove("first");
            }

            if (bgs[activeIndex]) {
              bgs[activeIndex].classList.add("active");
            }
          }, 15000);

          rotationIntervals.push(interval);
        }
      } catch (e) {
        // JSON Parse error
      }
    }
  });
})();
