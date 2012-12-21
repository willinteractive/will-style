# Place all the behaviors and hooks related to jQuery here.

jQuery ->
  
  # make placeholder attributes work in IE
  $(document).ready($('input[placeholder]').placeholder())