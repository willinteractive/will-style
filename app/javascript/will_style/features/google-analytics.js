(function() {
  'use strict';

  document.addEventListener('turbo:load', function(event) {
    if (typeof window.ga === 'function') {
      window.ga('send', 'pageview', window.location.pathname);
    }
  });
})();
