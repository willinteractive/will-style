# Place all the behaviors and hooks related to jQuery here.

#= require jquery.placeholder.js

$ ->
  # Make all inputs with a placeholder attribute into a placeholder
  $(document).ready($('input[placeholder]').placeholder())
