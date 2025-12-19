#= require 'growfield'

window.WILLStyle.Forms = {} unless window.WILLStyle.Forms
window.WILLStyle.Forms.initializeExpandingTextareas = ->
  growfield('.expanding')

$(document).on window.WILLStyle.Settings.pageChangeEvent, (event) ->
  window.WILLStyle.Forms.initializeExpandingTextareas()

$ ->
  window.WILLStyle.Forms.initializeExpandingTextareas()
