$(document).on 'turbolinks:load', (event) ->
  if typeof ga is 'function'
    ga('set', 'location', event.originalEvent.data.url)
    ga('send', 'pageview')
