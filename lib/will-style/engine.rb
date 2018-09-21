# Dependencies
require "sassc"
require "sassc-rails"
require "bootstrap"
require "font-awesome-rails"
require "autoprefixer-rails"
require "jquery-rails"
require "turbolinks"

module WILL
  module Style
    class Engine < Rails::Engine
      isolate_namespace WILL::Style

      # Include Foundation form helpers
      require "#{config.root}/lib/will-style/form_extensions/form_builder.rb"
      require "#{config.root}/lib/will-style/form_extensions/action_view_extension.rb"
    end

    # Using bootstrap-sass initialization
    class << self
      def load!
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

WILL::Style.load!
