//= require 'growfield'

(function() {
  'use strict';

  window.WILLStyle.Forms = window.WILLStyle.Forms || {};
  window.WILLStyle.Forms.initializeExpandingTextareas = function() {
    growfield('.expanding');
  };

  document.addEventListener(window.WILLStyle.Settings.pageChangeEvent, function(event) {
    window.WILLStyle.Forms.initializeExpandingTextareas();
  });

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function() {
      window.WILLStyle.Forms.initializeExpandingTextareas();
    });
  } else {
    window.WILLStyle.Forms.initializeExpandingTextareas();
  }
})();
