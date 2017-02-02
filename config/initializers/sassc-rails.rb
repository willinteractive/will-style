require "sprockets/engines"

module Extensions
  module Sprockets
    module Engines
      def register_engine(ext, klass, options = {})
        if defined?(Sass::Rails)
          return if [
            Sass::Rails::SassTemplate,
            Sass::Rails::ScssTemplate
          ].include?(klass)
        end

        super
      end
    end
  end
end

Sprockets::Base.send(:prepend, Extensions::Sprockets::Engines)

Rails.application.config.assets.configure do |env|
  if env.respond_to?(:register_engine)
    env.register_engine '.sass', SassC::Rails::SassTemplate, silence_deprecation: true
    env.register_engine '.scss', SassC::Rails::ScssTemplate, silence_deprecation: true
  end

  if env.respond_to?(:register_transformer)
    env.register_transformer 'text/sass', 'text/css',
      Sprockets::SassProcessor.new(importer: SassC::Rails::Importer, sass_config: Rails.application.config.sass)
    env.register_transformer 'text/scss', 'text/css',
      Sprockets::ScssProcessor.new(importer: SassC::Rails::Importer, sass_config: Rails.application.config.sass)
  end
end
