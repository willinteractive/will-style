spanifyElement = (element, force) ->
  element = $(element)

  unless element.attr('data-spanned') and force isnt true
    element.attr('data-spanned', true)

    text = element

    unless element.is("p,h1,h2,h3,h4,h5")
      text = $(element.find("p")[0])

    newHTML = ""
    for letter in text.text().trim()
      newHTML += "<span>#{letter}</span>"

    newHTML = newHTML.replace(/\s/gi, "&nbsp;")

    text.html(newHTML)

spanifyElements = ->
  $(".spannable").each ->
    spanifyElement this

$(document).on window.WILLStyle.Settings.pageChangeEvent, (event) ->
  spanifyElements()

$(document).on window.WILLStyle.Settings.elementChangedEvent, ".spannable", (event) ->
  spanifyElement event.currentTarget, true
