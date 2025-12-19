# Move Bootstrap Modals to the body so they're always on top of the overlay

document.addEventListener window.WILLStyle.Settings.pageChangeEvent, (event) ->
  for element in document.querySelectorAll(".modal")
    document.querySelector("body").append(element)
