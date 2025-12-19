# Dependencies
require "dartsass-sprockets"
require "bootstrap"
require "autoprefixer-rails"
require "jquery-rails"
require "turbo-rails"

module WILLStyle
  class Engine < Rails::Engine
    isolate_namespace WILLStyle
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

WILLStyle.load!
