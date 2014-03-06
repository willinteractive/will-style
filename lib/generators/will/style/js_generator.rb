module Will
  module Style
    module Generators
      class JsGenerator < Rails::Generators::Base
        desc "This generator creates a default will-style js file that you can include in your app"

        def create_js_file
          create_file "app/assets/javascripts/custom-will-style.js", File.open("#{File.expand_path("../../../../assets/javascripts/", __FILE__)}/will-style.js", "rb").read
        end
      end
    end
  end
end
