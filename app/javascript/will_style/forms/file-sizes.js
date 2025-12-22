(function() {
  'use strict';

  document.addEventListener("change", function(event) {
    const target = event.target;
    if (!target.hasAttribute("data-max-file-size")) {
      return;
    }

    const maxFileSize = parseInt(target.getAttribute('data-max-file-size'));

    if (target.files) {
      for (let i = 0; i < target.files.length; i++) {
        const file = target.files[i];
        if (file.size && maxFileSize && file.size > maxFileSize) {
          alert("This file exceeds the maximum allowed file size.");
          target.value = '';
          return;
        }
      }
    }
  }, true);
})();
