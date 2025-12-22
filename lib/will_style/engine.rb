# Dependencies
require "dartsass-sprockets"
require "bootstrap"
require "autoprefixer-rails"

require "importmap-rails"
require "turbo-rails"

module WillStyle
  class Engine < Rails::Engine
    isolate_namespace WillStyle

    initializer "will_style.javascript" do |app|
      app.config.assets.paths << root.join("app/javascript")
    end

    initializer "will_style.importmap", before: "importmap" do |app|
      WillStyle.importmap = Importmap::Map.new
      WillStyle.importmap.draw(app.root.join("config/importmap.rb"))
      WillStyle.importmap.draw(root.join("config/importmap.rb"))
      WillStyle.importmap.cache_sweeper(watches: root.join("app/javascript"))

      ActiveSupport.on_load(:action_controller_base) do
        before_action { WillStyle.importmap.cache_sweeper.execute_if_updated }
      end
    end
  end

  # Using bootstrap-sass initialization
  class << self
    attr_accessor :importmap

    def load!
    end

    # Paths
    def gem_path
      @gem_path ||= File.expand_path '..', File.dirname(__FILE__)
    end

    def stylesheets_path
      File.join assets_path, 'stylesheets'
    end
  end
end

WillStyle.load!
