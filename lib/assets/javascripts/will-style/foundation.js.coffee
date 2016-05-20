#= require foundation/foundation
#= require foundation/foundation.abide
#= require foundation/foundation.accordion
#= require foundation/foundation.alert
#= require foundation/foundation.clearing
#= require will-style/foundation/foundation.dropdown.fixed
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

#= require will-style/foundation/fixes

# Update Foundation components to allow for custom behaviors
Foundation.libs.reveal.settings.dismiss_modal_class = 'close-reveal-modal, .reveal-close'

# Initialize Foundation
$(document).on 'turbolinks:load', ->
  # @NOTE: Foundation interchange needs to be reflowed when using with turbolinks.
  # $(document).foundation('interchange', 'reflow');

  $(document).foundation
    # Focus inputs in dropdowns if they have one
    dropdown:
      opened: (event) ->
        if $(this).find("input[type='text']").length > 0
            $(this).find("input[type='text']").focus()

    # Don't duplicate parent link on topbars
    topbar:
      mobile_show_parent_link: false
      back_text: '<i class="fa fa-arrow-left"></i> BACK'
