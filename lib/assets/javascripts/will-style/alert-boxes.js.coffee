# Activate / Deactivate floating alert boxes on page load
$(document).on "show-alert", "div.alert-box.float", (event) ->
	setTimeout(->
		$(event.target).addClass "active"

		setTimeout(->
			$(event.target).removeClass "active"
		, 5000)
	, 500)

$(document).on "click", "div.alert-box.float .close", (event) ->
	$(event.target).closest("div.alert-box").removeClass("active")

$ ->
	$("div.alert-box.float").trigger("show-alert")
