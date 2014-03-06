# Dependencies
require "sass"
require "sass-rails"
require "compass-rails"
require "bootstrap-sass"
require "font-awesome-rails"

module Will
  module Style
    class Engine < Rails::Engine
    end

    # Using bootstrap-sass initialization
    class << self
      def load!
        if defined?(::Rails)
          require 'sass-rails'
          ::Sass.load_paths << stylesheets_path
        end
      end

      # Paths
      def gem_path
        @gem_path ||= File.expand_path '..', File.dirname(__FILE__)
      end

      def stylesheets_path
        File.join assets_path, 'stylesheets'
      end

      def assets_path
        @assets_path ||= File.join gem_path, 'vendor', 'assets'
      end
    end
  end
end

Will::Style.load!
