# @NOTE: Turbolinks fails when trying to run replaceState on IE9 in production, killing all Javascript. This should fix it.
unless window.history.replaceState?
  window.history.replaceState = ->
    # Do Nothing
