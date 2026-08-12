# frozen_string_literal: true

# Importmap::Map#absolute_root_of always resolves a relative pin_all_from dir
# against the *host app's* Rails.root, never against this file's own
# location -- so a relative path here silently resolves to a directory
# outside any consuming app and expands to nothing. Anchor to the engine's
# own root instead.
pin_all_from WillStyle::Engine.root.join('app/javascript/will_style').to_s, under: 'will_style'
pin 'will_style', to: 'will_style.js', preload: true
