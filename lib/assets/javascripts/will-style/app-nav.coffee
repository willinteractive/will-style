isPrimaryNavOpen = ->
  $('.cd-menu-icon').hasClass('is-clicked') or $('.cd-header').hasClass('menu-is-open') or $('.cd-primary-nav').hasClass('is-visible')

closePrimaryNav = ->
  $('.cd-menu-icon').removeClass 'is-clicked'
  $('.cd-header').removeClass 'menu-is-open'
  $('.cd-primary-nav').removeClass('is-visible').one 'webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend'

openPrimaryNav = ->
  $('.cd-menu-icon').addClass 'is-clicked'
  $('.cd-header').addClass 'menu-is-open'
  $('.cd-primary-nav').addClass('is-visible').one 'webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend'

togglePrimaryNav = (event) ->
  event.stopImmediatePropagation()
  event.preventDefault()

  if isPrimaryNavOpen()
    closePrimaryNav()
  else
    openPrimaryNav()
  false

# @NOTE: Commenting out the affixing header – if we want to restore this, we can
# headerHeight = undefined

# $(document).on 'turbolinks:load', ->
#   headerHeight = $('.cd-header').height()

# $(window).on 'scroll', { previousTop: 0 }, ->
#   currentTop = $(window).scrollTop()

#   # if scrolling up
#   if currentTop < @previousTop
#     if currentTop > 0 and $('.cd-header').hasClass('is-fixed')
#       $('.cd-header').addClass 'is-visible'
#     else
#       $('.cd-header').removeClass 'is-visible is-fixed'

#   # if scrolling down
#   else
#     $('.cd-header').removeClass 'is-visible'
#     if currentTop > headerHeight and !$('.cd-header').hasClass('is-fixed')
#       $('.cd-header').addClass 'is-fixed'

#   @previousTop = currentTop

$(window).resize closePrimaryNav

$(document).on 'click', '.cd-primary-nav-trigger', togglePrimaryNav
