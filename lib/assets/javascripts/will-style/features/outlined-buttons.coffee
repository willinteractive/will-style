#------------------------------
# Initialize Outlined Buttons -
#------------------------------

$(document).on window.WILLStyle.Settings.pageChangeEvent, (event) ->
  $(".button-container").each ->
    $('<div class="button-outline-outer"><div class="button-outline-inner"></div></div>').appendTo(this)
