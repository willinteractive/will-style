#= require modernizr

# jQuery.sidebar:
# Turns a div into a sidebar element
(($, undefined_) ->
  SideBar = (target, userSettings) ->
    # Set up settings
    settings = $.extend({}, defaultSettings, userSettings or {})

    defaultSettings =
        default_effect: "slide"

    # Default effects that animate over content
    effects = [
        "slide"
        "reveal"
        "slide-along"
        "reverse-slide-out"
        "scale-down"
        "scale-up"
        "scale-and-rotate"
        "open-door"
        "fall-down"
    ]

    # Effects that push content over
    push_effects = [
        "push"
        "rotate"
        "3d-rotate-in"
        "3d-rotate-out"
        "delayed-3d-rotate"
    ]

    # Generate necessary components if we don't have them
    target.append('<nav class="sidebar-menu"></nav>') if target.find(".sidebar-menu").length is 0

    if target.find(".sidebar-pusher").length is 0
        target.append('<div class="sidebar-pusher"></nav>')

        if target.find(".sidebar-content").length isnt 0
            target.find(".sidebar-pusher").append target.find(".sidebar-content")
        
    target.find(".sidebar-pusher").append('<div class="sidebar-content"></nav>') if target.find(".sidebar-content").length is 0

    # Store the original sidebar-container class so we can reset
    target.addClass("sidebar-container") 
    original_target_class = target.attr("class")

    # Store the original menu class so we can reset
    menu = target.find(".sidebar-menu")
    original_menu_class = menu.attr("class")

    # Store the trigger event as touch or click (whichever is available)
    event_type = if Modernizr.touch then "touchstart" else "click"

    # Hide the sidebar when clicking on the body
    body_click = (event) ->
      if $(event.target).closest(".sidebar-menu").length is 0
        target.removeClass "sidebar-menu-open"

        $(document).off event_type, body_click
      return

    # Toggle sidebar when clicking on a sidebar button
    target.on event_type, ".sidebar-button", (event) ->
        event.stopPropagation()
        event.preventDefault()
        
        # Get the effect type (default or custom if specified in data-effect)
        new_effect = settings.default_effect
        if $(event.currentTarget).attr("data-effect") && effects.concat(push_effects).indexOf($(event.currentTarget).attr("data-effect")) isnt -1
            new_effect = $(event.currentTarget).attr("data-effect")

        # Move the menu to either the pusher or the main content area
        # based on where the menu is supposed to exist
        if push_effects.indexOf(new_effect) isnt -1
            target.find(".sidebar-pusher").prepend(menu)
        else
            target.prepend(menu)

        # Trigger the effect by applying classes
        target.attr("class", original_target_class)
        target.addClass "sidebar-effect-#{new_effect}"

        menu.attr("class", original_menu_class)
        menu.addClass "sidebar-effect-#{new_effect}"

        setTimeout (->
          target.addClass "sidebar-menu-open"
          return
        ), 25

        # Add a listener to the body to hide the sidebar
        $(document).on event_type, body_click
        return
    return

  $.fn.sidebar = (settings, target) ->
    @each ->
        target = $(this)
        @sidebar = new SideBar(target, settings) if typeof @sidebar is "undefined"
        return

  return
) jQuery

# Initialize any sidebar container divs as a Sidebar
$ ->
    $("div.sidebar-container").sidebar
        default_effect: "reveal"
