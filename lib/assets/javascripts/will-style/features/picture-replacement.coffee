webpTimeout = undefined

processWebPContent = ->
  if $("html").hasClass("webp") or $("html").hasClass("no-webp")
    hasWebp = $("html").hasClass("webp")

    $("picture").each ->
      newImage = $("<img>")

      if hasWebp or $(this).find("source").length is 1
        newImage.attr("src", $($(this).find("source")[0]).attr("srcset"))
      else
        newImage.attr("src", $($(this).find("source")[1]).attr("srcset"))

      newImage.attr("class", $(this).attr("class"))

      for attribute in this.attributes
        newImage.attr(attribute.name, attribute.value)

      $(this).replaceWith(newImage)

  else
    clearTimeout webpTimeout if webpTimeout
    webpTimeout = setTimeout processWebPContent, 100

$(document).on "turbolinks:load", processWebPContent
