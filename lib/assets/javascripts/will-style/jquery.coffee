# Place all the behaviors and hooks related to jQuery here.

#= require jquery.placeholder.js

$(document).on 'turbolinks:load', ->
  # Make all inputs with a placeholder attribute into a placeholder
  $('input[placeholder]').placeholder()
