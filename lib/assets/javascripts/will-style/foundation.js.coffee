#= require foundation/foundation
#= require foundation/foundation.abide
#= require foundation/foundation.accordion
#= require foundation/foundation.alert
#= require foundation/foundation.clearing
#= require foundation/foundation.dropdown
#= require foundation/foundation.interchange
#= require foundation/foundation.joyride
#= require foundation/foundation.magellan
#= require foundation/foundation.offcanvas
#= require foundation/foundation.orbit
#= require foundation/foundation.reveal
#= require foundation/foundation.slider
#= require foundation/foundation.tab
#= require foundation/foundation.tooltip
#= require foundation/foundation.topbar
#= require foundation/foundation.equalizer

# Update Foundation components to allow for custom behaviors
Foundation.libs.reveal.settings.dismiss_modal_class = 'close-reveal-modal, .reveal-close'

# Prevent disabled dropdown buttons from triggering a dropdown
$(document).on 'click touchstart', 'a.dropdown', (event) ->
	if $(event.currentTarget).attr("data-dropdown") && $(event.currentTarget).attr("disabled")
		event.stopImmediatePropagation()
		event.stopPropagation()
		event.preventDefault()

		return false

	return true

# Make dropdowns buttons with rich html content work
#
# https://github.com/zurb/foundation/issues/4891
$(document).on 'click touchstart', 'a.dropdown > *', (event) ->
	button = $(event.target).closest("a.dropdown")

	# Only trigger a click on the parent element if we need to turn the dropdown on.
	# ------------------------------------------------------------------------------
	#
	# Clicking to open the dropdown doesn't work because
	# it doesn't consider the content to be within the button.
	#
	# Clicking to close a dropdown works fine since clicking on the element
	# isn't considered within the button. 
	if $("##{button.attr("data-dropdown")}.open").length == 0
		# Delay until the next run cycle because you can't
		# trigger multiple clicks in the same run cycle
		setTimeout(->
			$(event.target).closest("a.dropdown").trigger("click")
		, 0)

# Initialize Foundation
$ ->
	$(document).foundation
		# Focus inputs in dropdowns if they have one
		dropdown:
    		opened: (event) ->
    			if $(this).find("input[type='text']").length > 0
    				$(this).find("input[type='text']").focus()
