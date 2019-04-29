$(document).on "keyup paste change", "input[type=url]", (event) ->
  new_value =  $.urlify($(event.target).val(), true)
  $(event.target).val(new_value) if new_value isnt $(event.target).val()
