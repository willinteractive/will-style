# Activate / Deactivate floating alert boxes on page load
$(document).on "show-alert", "div.alert-box.float", (event) ->
	setTimeout(->
		$(event.target).addClass "active"

		setTimeout(->
			$(event.target).removeClass "active"
		, 5000)
	, 500)

$ ->
	$("div.alert-box.float").trigger("show-alert")
