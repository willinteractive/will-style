(function() {
  'use strict';

  window.WillStyle.Forms = window.WillStyle.Forms || {};
  window.WillStyle.Forms.initializeExpandingTextareas = function() {
    growfield('.expanding');
  };

  document.addEventListener(window.WillStyle.Settings.pageChangeEvent, function(event) {
    window.WillStyle.Forms.initializeExpandingTextareas();
  });

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function() {
      window.WillStyle.Forms.initializeExpandingTextareas();
    });
  } else {
    window.WillStyle.Forms.initializeExpandingTextareas();
  }
})();
