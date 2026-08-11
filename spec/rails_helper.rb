ENV["RAILS_ENV"] ||= "test"
require "spec_helper"
require "rubygems"
require "bundler/setup"

require "simplecov"
SimpleCov.start "rails"

require "combustion"

# will-style has no ActiveRecord models, so the dummy app only needs the
# controller/view stack for the engine and its helpers to boot against.
Combustion.initialize! :action_controller, :action_view

require "rspec/rails"

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.order = "random"
end
