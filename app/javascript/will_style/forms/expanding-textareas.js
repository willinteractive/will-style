import { Settings } from "will_style/core/settings";

function initializeExpandingTextareas() {
  growfield('.expanding');
}

// Compatibility shim: window.WillStyle.Forms.initializeExpandingTextareas
// was the public surface under the old IIFE/Sprockets setup, and nothing
// in this repo confirms no consuming app calls it directly (e.g. after
// injecting a form via AJAX) -- kept deliberately, not a leftover.
window.WillStyle = window.WillStyle || {};
window.WillStyle.Forms = window.WillStyle.Forms || {};
window.WillStyle.Forms.initializeExpandingTextareas = initializeExpandingTextareas;

document.addEventListener(Settings.pageChangeEvent, function(event) {
  initializeExpandingTextareas();
});

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', function() {
    initializeExpandingTextareas();
  });
} else {
  initializeExpandingTextareas();
}
