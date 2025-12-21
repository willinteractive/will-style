(function() {
  'use strict';

  window.WILLStyle = window.WILLStyle || {};

  // Set up some default settings for common tasks
  if (!window.WILLStyle.Settings) {
    window.WILLStyle.Settings = {
      pageChangeEvent: "turbo:load",
      synchronousCSS: true
    };
  }

  window.WILLStyle.Settings.elementChangedEvent = "will-style:elementChanged";
})();
