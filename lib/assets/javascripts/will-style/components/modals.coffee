# Move Bootstrap Modals to the body so they're always on top of the overlay

$(document).on window.WILLStyle.Settings.pageChangeEvent, (event) ->
  $(".modal").appendTo("body")
