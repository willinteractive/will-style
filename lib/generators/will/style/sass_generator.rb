module Will
  module Style
    module Generators
      class SassGenerator < Rails::Generators::Base
        desc "This generator creates a default will-style sass file that you can include in your app"

        def create_sass_file
          create_file "app/assets/stylesheets/custom-will-style.scss", File.open("#{File.expand_path("../../../../assets/stylesheets/will-style/", __FILE__)}/will-style.scss", "rb").read
        end
      end
    end
  end
end
