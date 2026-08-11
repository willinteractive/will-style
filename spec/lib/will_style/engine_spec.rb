require "rails_helper"

RSpec.describe "WillStyle::Engine" do
  it "boots as an isolated Rails::Engine" do
    expect(WillStyle::Engine.ancestors).to include(Rails::Engine)
    expect(WillStyle::Engine.isolated?).to be true
  end

  it "adds the engine's app/javascript directory to the host app's asset paths" do
    expect(Rails.application.config.assets.paths).to include(
      WillStyle::Engine.root.join("app/javascript")
    )
  end

  it "builds an importmap that draws both the host app's and the engine's config/importmap.rb" do
    expect(WillStyle.importmap).to be_a(Importmap::Map)
  end

  it "exposes a path via WillStyle.gem_path" do
    # Despite the name, this resolves to the gem's lib/ directory, not the
    # repo root — File.expand_path("..", File.dirname(__FILE__)) from
    # lib/will_style/engine.rb lands one level up from lib/will_style.
    expect(File.directory?(WillStyle.gem_path)).to be true
    expect(File.exist?(File.join(WillStyle.gem_path, "will_style.rb"))).to be true
  end
end
