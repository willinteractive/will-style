#= require jquery.isEmail

update_submit = (form) ->
  disabled = false

  form.find(".required").each ->
    # Ensure we're in the correct form and it's not a select2 hidden element
    if $(this).closest("form").is(form) and ($(this).attr("id") and $(this).attr("id").indexOf("s2") isnt 0)
      disabled = true if $(this).val() is null or $(this).val() is ""

      # Enforce valid email addresses on email fields
      disabled = true if $(this).attr("type") is "email" and $.isEmail($(this).val()) is false

  # Only disable primary submit buttons
  form.find("input[type=submit]:not(.alert, .secondary)").prop("disabled", disabled)

update_required = (element) ->
  label = $(element).siblings(".required-label")
  label = $(element).closest("section").find(".required-label") if label.length == 0

  # Ensure it's not a select2 hidden element
  unless $(element).attr("id") and $(element).attr("id").indexOf("s2") is 0
    disabled = false
    disabled = true if $(element).val() is null or $(element).val() is ""

    # Enforce valid email addresses on email fields
    disabled = true if $(element).attr("type") is "email" and $.isEmail($(element).val()) is false

    if disabled
      label.removeClass("success")
      label.addClass("alert")
    else
      label.addClass("success")
      label.removeClass("alert")

$(document).on "change propertychange keyup input paste", ".required", ->
  update_required(this)
  update_submit($(this).closest("form"))

$(document).on 'turbolinks:load', ->
  $(".required").trigger "change"
