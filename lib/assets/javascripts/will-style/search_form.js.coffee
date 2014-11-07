$(document).on "click", "a.search-button", (event) ->
	event.preventDefault()
	event.stopPropagation()

	if $(event.currentTarget).closest("form").length > 0
		$(event.currentTarget).closest("form").submit()
