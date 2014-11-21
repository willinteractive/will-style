$(window).scroll ->
	return unless $("#will-header").length > 0
	header = $("#will-header")

	if $(window).scrollTop() > 0
		header.addClass("opaque") unless header.hasClass("opaque")
	else
		header.removeClass("opaque") if header.hasClass("opaque")
