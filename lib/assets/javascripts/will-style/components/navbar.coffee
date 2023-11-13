# Add collapsing out functionality to the navbar on small screens
$(document).on "click tap", ".navbar-toggler", (event)->
  button = $(event.currentTarget)

  if button.attr("aria-expanded") is "false"
    menu = button.siblings(".navbar-collapse")
    menu.addClass("collapsing-out")

    iterationCount = 0
    checkInterval = setInterval ->
      if menu.hasClass("collapsing") is false or iterationCount++ > 100
        menu.removeClass("collapsing-out")

        if checkInterval
          clearInterval(checkInterval)
          checkInterval = undefined
    , 1000 / 4

# Add class on navbar to make sure it's on top of content
$(document).on "click tap", ".navbar-toggler", (event)->
  button = $(event.currentTarget)

  if button.attr("aria-expanded") is "false"
    $("body").removeClass("navbar-active")
  else
    $("body").addClass("navbar-active")

_cachedNavHeight = -1

_checkNavbarObscure = ->
  if $("nav.navbar.fixed").length > 0
    _cachedNavHeight = $("nav.navbar.fixed").outerHeight()
    addObscureClass = false

    if _cachedNavHeight > 0
      addObscureClass = $(window).scrollTop() > $("nav.navbar.fixed").outerHeight()

    if addObscureClass
      $("nav.navbar.fixed").addClass("obscure")
    else
      $("nav.navbar.fixed").removeClass("obscure")

# Add class on navbar to make sure it's on top of content
$(window).on "scroll", _checkNavbarObscure

$(window).on "resize", (event)->
  _cachedNavHeight = -1
  _checkNavbarObscure()
