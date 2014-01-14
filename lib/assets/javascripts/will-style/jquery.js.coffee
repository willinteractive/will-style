# Place all the behaviors and hooks related to jQuery here.

#= require jquery.placeholder.min.js

$ ->
  # make placeholder attributes work in IE
  $(document).ready($('input[placeholder]').placeholder())
