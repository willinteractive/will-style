# Place all the behaviors and hooks related to Bootstrap here.
jQuery ->
  
  $("a[rel=popover]").popover()
  
  $('.popover-bottom').popover({
    placement: "bottom"
  })
  $('.popover-right').popover({
    placement: "right",
    html: true;
  })
  
  # tooltips 
  $("a[rel^=tooltip]").tooltip()



