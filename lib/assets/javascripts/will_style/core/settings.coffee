window.WILLStyle = {} unless window.WILLStyle

# Set up some default settings for common tasks
unless window.WILLStyle.Settings
  window.WILLStyle.Settings =
    pageChangeEvent: "turbo:load"
    synchronousCSS: true

window.WILLStyle.Settings.elementChangedEvent = "will-style:elementChanged"
