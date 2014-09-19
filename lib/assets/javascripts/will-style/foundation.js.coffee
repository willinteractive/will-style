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
$(document).on 'click touchstart', 'a[data-dropdown]', (event) ->
    if $(event.currentTarget).attr("disabled") || $(event.currentTarget).hasClass "disabled"
        event.stopImmediatePropagation()
        event.stopPropagation()
        event.preventDefault()

        return false

    return true

# Initialize Foundation
$ ->
    # @NOTE: Foundation interchange is currently broken with turbolinks
    # It keeps a image cache of DOM elements. When turbolinks removes the body,
    # the cache is gone, but Foundation still thinks it's there, so we have to
    # manually remove it.
    delete Foundation.libs.interchange.cached_images

    $(document).foundation
        # Focus inputs in dropdowns if they have one
        dropdown:
            opened: (event) ->
                if $(this).find("input[type='text']").length > 0
                    $(this).find("input[type='text']").focus()
        # Don't duplicate parent link on topbars
        topbar:
            mobile_show_parent_link: false
