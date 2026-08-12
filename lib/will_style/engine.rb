# frozen_string_literal: true

# Dependencies
require 'dartsass-sprockets'
require 'bootstrap'
require 'autoprefixer-rails'

require 'importmap-rails'
require 'turbo-rails'

module WillStyle
  class Engine < Rails::Engine
    isolate_namespace WillStyle

    initializer 'will_style.javascript' do |app|
      js_root = root.join('app/javascript')
      app.config.assets.paths << js_root

      # Sprockets::Rails raises AssetNotPrecompiledError for anything not in
      # config.assets.precompile, independent of importmap-rails -- a
      # consuming app's manifest.js only declares the "will_style" aggregate
      # entry point, not the individual will_style/*.js files the ESM
      # aggregate now imports by name (as of 7.0.0). Declare the whole tree
      # here so no consuming app has to hand-maintain this list.
      #
      # A Regexp entry here looks like the idiomatic way to do this, but
      # Sprockets::Manifest#find passes precompile entries straight into
      # Sprockets::Resolve#resolve, which calls `path.start_with?` on
      # whatever it's given -- a Regexp blows up there, not with a precompile
      # error but with an unrelated NoMethodError the first time *any* asset
      # gets resolved (it corrupts the memoized precompiled-assets set for
      # the whole request). Enumerate literal logical paths instead, the
      # same shape "will_style.js" already resolves as below.
      Dir.glob(js_root.join('will_style/**/*.js')).each do |file|
        app.config.assets.precompile << Pathname.new(file).relative_path_from(js_root).to_s
      end
    end

    initializer 'will_style.importmap', before: 'importmap' do |app|
      # Registers this engine's pins (pin_all_from "will_style/...", the
      # "will_style" aggregate entry point) with importmap-rails' own
      # app.config.importmap.paths, so they land in Rails.application.importmap
      # -- the map javascript_importmap_tags actually renders in the host
      # app's <script type="importmap">. Without this, app/javascript/will_style.js's
      # `import "will_style/core/settings"` etc. (real ESM as of 7.0.0) are
      # bare specifiers the browser can't resolve, even though they parse and
      # test fine from this repo.
      app.config.importmap.paths << root.join('config/importmap.rb')
      app.config.importmap.cache_sweepers << root.join('app/javascript')

      # Kept for backward compatibility: WillStyle.importmap is public API
      # (a consuming app's own JS/Ruby could reference it) even though the
      # line above is now what actually drives rendering.
      WillStyle.importmap = Importmap::Map.new
      WillStyle.importmap.draw(app.root.join('config/importmap.rb'))
      WillStyle.importmap.draw(root.join('config/importmap.rb'))
      WillStyle.importmap.cache_sweeper(watches: root.join('app/javascript'))

      ActiveSupport.on_load(:action_controller_base) do
        before_action { WillStyle.importmap.cache_sweeper.execute_if_updated }
      end
    end
  end

  class << self
    attr_accessor :importmap

    def load!; end

    # Paths
    def gem_path
      @gem_path ||= File.expand_path '..', File.dirname(__FILE__)
    end
  end
end

WillStyle.load!
