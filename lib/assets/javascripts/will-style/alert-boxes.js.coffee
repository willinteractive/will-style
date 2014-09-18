# Activate / Deactivate floating alert boxes on page load
$ ->
	setTimeout(->
		$("div.alert-box.float").addClass "active"

		setTimeout(->
			$("div.alert-box.float").removeClass "active"
		, 5000)
	, 500)
