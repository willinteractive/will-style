$(document).on 'turbolinks:load', (event) ->
  if typeof window.ga is 'function'
    window.ga('send', 'pageview', window.location.pathname)
