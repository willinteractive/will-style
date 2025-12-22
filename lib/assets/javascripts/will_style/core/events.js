(function() {
  'use strict';

  window.WillStyle = window.WillStyle || {};

  if (window.WillStyle.Events) {
    return;
  }

  window.WillStyle.Events = {
    trigger: function(name, data) {
      const eventName = `will-style:${name}`;
      const eventData = Array.isArray(data) ? data : [data];
      const event = new CustomEvent(eventName, { detail: eventData });
      document.dispatchEvent(event);
    },

    on: function(name, handler) {
      const eventName = `will-style:${name}`;
      document.addEventListener(eventName, function(event) {
        const data = event.detail && event.detail.length > 0 ? event.detail[0] : event.detail;
        handler(data);
      });
    }
  };
})();
