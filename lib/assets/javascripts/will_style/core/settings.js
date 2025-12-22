(function() {
  'use strict';

  window.WillStyle = window.WillStyle || {};

  // Set up some default settings for common tasks
  if (!window.WillStyle.Settings) {
    window.WillStyle.Settings = {
      pageChangeEvent: "turbo:load",
      synchronousCSS: true
    };
  }

  window.WillStyle.Settings.elementChangedEvent = "will-style:elementChanged";
})();

document.addEventListener("turbo:load", function() {
  console.log("TURBO:LOAD");
})