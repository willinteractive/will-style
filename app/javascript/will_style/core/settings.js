export const Settings = {
  pageChangeEvent: "turbo:load",
  synchronousCSS: true,
  elementChangedEvent: "will-style:elementChanged"
};

// Compatibility shim: window.WillStyle.Settings was the public surface
// under the old IIFE/Sprockets setup, and nothing in this repo confirms
// no consuming app's own JS reads it directly -- kept deliberately
// alongside the real export above, not a transitional leftover.
window.WillStyle = window.WillStyle || {};
window.WillStyle.Settings = Settings;
