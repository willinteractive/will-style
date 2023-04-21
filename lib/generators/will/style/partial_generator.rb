module FontAwesomeStubHelper
  def icon(names = "flag", options = {})
    return "<%= icon \"#{(names.is_a?(Array) ? names.join(" ") : names)}\"#{(options.keys.length > 0 ? " " + options.inspect : "") } %>".html_safe
  end

  def fa_stacked_icon(names = "flag", options = {})
    return "<%= fa_stacked_icon \"#{(names.is_a?(Array) ? names.join(" ") : names)}\"#{(options.keys.length > 0 ? " " + options.inspect : "") } %>".html_safe
  end
end

class Renderer < ActionController::Base
  helper FontAwesomeStubHelper
end

module Will
  module Style
    module Generators
      class PartialGenerator < Rails::Generators::Base
        desc "This copies a partial to the clipboard for you (OSX Only). Use with no arguments to get a list of available partials."

        argument :partial_name, type: :string, default: ""

        def partial
          partials = Dir.entries(File.expand_path("../../../../../app/views/will-style/elements", __FILE__))

          cleaned_partials = []
          partials.each do |partial|
            cleaned_partials << partial.gsub(/^_/, "") unless partial == "." || partial == ".." || partial == ".DS_Store"
          end

          partials = cleaned_partials

          if partial_name == ""
            p "Available partials"
            p "--------------------------------"
            partials.each do |partial|
              p partial.gsub(".html.erb", "")
            end
          else
            found_partial = false

            partials.each do |partial|
              if partial.gsub(".html.erb", "").downcase == partial_name.downcase
                found_partial = true

                file_content = File.read(File.expand_path("../../../../../app/views/will-style/elements/_#{partial}", __FILE__))

                # Render out any sub-partials (and use our icon stub to not render those)
                file_content = Renderer.new().render_to_string(partial: "will-style/elements/" + partial.gsub(".html.erb", "").downcase)

                pbcopy file_content
                p "Partial copied to clipboard"
              end
            end

            p "Could not find partial by the name '#{partial_name}'. Use this generator without any arguments to see a list of partials." if found_partial == false
          end
        end

        private
          def pbcopy(input)
            str = input.to_s
            IO.popen('pbcopy', 'w') { |f| f << str }
            str
          end
      end
    end
  end
end
