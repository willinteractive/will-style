# Place all the behaviors and hooks related to Bootstrap here.
jQuery ->
  
  $("a[rel=popover]").popover({
    html: true;
  })
  $("a[rel^=tooltip]").tooltip()