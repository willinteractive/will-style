###
Add classes for css capabilities that modernizr doesn't detect

@module CSS Capabilities
###
areClipPathShapesSupported = ->
  `var i`
  `var l`
  base = 'clipPath'
  prefixes = [
    'webkit'
    'moz'
    'ms'
    'o'
  ]
  properties = [ base ]
  testElement = document.createElement('testelement')
  attribute = 'polygon(50% 0%, 0% 100%, 100% 100%)'
  # Push the prefixed properties into the array of properties.
  i = 0
  l = prefixes.length
  while i < l
    prefixedProperty = prefixes[i] + base.charAt(0).toUpperCase() + base.slice(1)
    # remember to capitalize!
    properties.push prefixedProperty
    i++
  # Interate over the properties and see if they pass two tests.
  i = 0
  l = properties.length
  while i < l
    property = properties[i]
    # First, they need to even support clip-path (IE <= 11 does not)...
    if testElement.style[property] == ''
      # Second, we need to see what happens when we try to create a CSS shape...
      testElement.style[property] = attribute
      if testElement.style[property] != ''
        return true
    i++
  false

$ ->
  maskClass = "mask-images"

  if navigator

    # IE
    if navigator.userAgent.match(/Windows/i) isnt null or navigator.userAgent.match(/MSIE/i) isnt null
      maskClass = "no-mask-images"

    # FF 52 and below

    if navigator.userAgent.match(/Firefox/i) isnt null
      versionMatch = navigator.userAgent.match(/Firefox\/[\d]+/i)

      if versionMatch isnt null
        version = parseInt(versionMatch[0].replace(/Firefox\//, ""))

        if version < 52
          maskClass = "no-mask-images"

  $("html").addClass(maskClass)
  $("html").addClass(if areClipPathShapesSupported() then "clip-paths" else "no-clip-paths" )
