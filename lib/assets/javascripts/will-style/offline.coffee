#= require offline.0.7.11.min

# Fake DOMContentLoaded event when page changes so offline.js works.
# (This is a crappy idea, but their modal attach code is locked down.
#  The only other solution is to make our own event and modify the offline.js code.)
lastLocation = ""

$(document).on 'turbolinks:load', ->
  if window.location.href isnt lastLocation
    lastLocation = window.location.href

    if document.createEvent
      event = document.createEvent("HTMLEvents")
      event.initEvent "DOMContentLoaded", true, true
    else
      event = document.createEventObject()
      event.eventType = "DOMContentLoaded"

    event.eventName = "DOMContentLoaded"

    if document.createEvent
      document.dispatchEvent event
    else
      document.fireEvent "on" + event.eventType, event
