export function trigger(name, data) {
  const eventName = `will-style:${name}`;
  const eventData = Array.isArray(data) ? data : [data];
  const event = new CustomEvent(eventName, { detail: eventData });
  document.dispatchEvent(event);
}

export function on(name, handler) {
  const eventName = `will-style:${name}`;
  document.addEventListener(eventName, function(event) {
    const data = event.detail && event.detail.length > 0 ? event.detail[0] : event.detail;
    handler(data);
  });
}

// Compatibility shim, not a transitional leftover: the deferred-styles
// inline <script> (app/views/will_style/components/_deferred_styles.html.erb)
// runs outside the module graph and polls window.WillStyle.Events directly
// to fire the css-initialized event as soon as the stylesheet link loads.
window.WillStyle = window.WillStyle || {};
window.WillStyle.Events = { trigger, on };
