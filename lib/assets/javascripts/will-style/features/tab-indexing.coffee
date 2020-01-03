# Automate Tab Indexing

$(document).on 'turbolinks:load', (event) ->
  currentIndex = 1

  $(".nav-link, .dropdown-item").each ->
    $(this).attr("tabindex", currentIndex++)