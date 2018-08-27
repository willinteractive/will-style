window.WILLStyle = {} unless window.WILLStyle

return if window.WILLStyle.Settings

window.WILLStyle.Settings =
  pageChangeEvent: "turbolinks:load"
  synchronousCSS: true
