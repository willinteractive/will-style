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

# Initialize Foundation
$ ->
	$(document).foundation()
