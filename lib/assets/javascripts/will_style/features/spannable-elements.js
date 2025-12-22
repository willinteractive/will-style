(function() {
  'use strict';

  function spanifyElement(element, force) {
    if (typeof element === 'string' || element instanceof NodeList) {
      element = element[0] || element;
    }

    if (!element.hasAttribute('data-spanned') || force === true) {
      element.setAttribute('data-spanned', 'true');

      let text = element;

      if (!element.matches("p, h1, h2, h3, h4, h5")) {
        const pElement = element.querySelector("p");
        if (pElement) {
          text = pElement;
        }
      }

      let newHTML = "";
      const textContent = text.textContent.trim();
      for (let i = 0; i < textContent.length; i++) {
        const letter = textContent[i];
        newHTML += `<span>${letter}</span>`;
      }

      newHTML = newHTML.replace(/\s/gi, "&nbsp;");

      text.innerHTML = newHTML;
    }
  }

  function spanifyElements() {
    const spannableElements = document.querySelectorAll(".spannable");
    for (let i = 0; i < spannableElements.length; i++) {
      spanifyElement(spannableElements[i]);
    }
  }

  document.addEventListener(window.WillStyle.Settings.pageChangeEvent, function(event) {
    spanifyElements();
  });

  document.addEventListener(window.WillStyle.Settings.elementChangedEvent, function(event) {
    const target = event.target;
    if (target.classList.contains("spannable")) {
      spanifyElement(target, true);
    }
  });
})();
