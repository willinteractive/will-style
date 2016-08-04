# @FIX: Support for jQuery datepickers inline in Foundation dropdowns.
#
# jQuery Datepicker doesn't actually render inline,
#   therefore trying to render an inline datepicker inside a foundation popover doesn't work.
#   Clicking previous / next month buttons will dismiss the popover.
#
#   This hack adds a stub data-dropdown-content attribute to the parent,
#   which tricks the foundation dropdown to stay open.
$(document).on "click touchstart", ".ui-datepicker-next, .ui-datepicker-prev", (event) ->
    $(this).parent().attr("data-dropdown-content", "hackadoo")
