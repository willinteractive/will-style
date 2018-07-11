# Place all the behaviors and hooks related to jQuery here.

#= require jquery.placeholder.js

$(document).on window.WILLStyleSettings.pageChangeEvent, ->
  # Make all inputs with a placeholder attribute into a placeholder
  $('input[placeholder]').placeholder()
