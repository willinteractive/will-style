# Automate Tab Indexing

$(document).on 'turbo:load', (event) ->
  currentIndex = 1

  $(".nav-link, .dropdown-item").each ->
    $(this).attr("tabindex", currentIndex++)