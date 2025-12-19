$(document).on "keyup", "input[data-type=url]", (event) ->
  new_value =  $.urlify($(event.target).val(), true)
  $(event.target).val(new_value) if new_value isnt $(event.target).val()

$(document).on "blur paste change", "input[data-type=url]", (event) ->
  new_value =  $.urlify($(event.target).val(), false)
  $(event.target).val(new_value) if new_value isnt $(event.target).val()

$(document).on "submit", "form", (event) ->
  $(event.target).find("input[data-type=url]").each ->
    $(this).val($.urlify($(this).val(), false))
