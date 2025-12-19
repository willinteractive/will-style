window.WILLStyle = {} unless window.WILLStyle

return if window.WILLStyle.Events

window.WILLStyle.Events =
  trigger: (name, data) ->
    $(document).trigger "will-style:#{name}", if Array.isArray(data) then data else [ data ]

  on: (name, handler) ->
    $(document).on "will-style:#{name}", (event, data) ->
      handler(data)
