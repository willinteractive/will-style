# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'will_style/components/_email', type: :view do
  it 'renders without error when premailer-rails is not installed' do
    expect(defined?(PremailerRails)).to be_nil

    render(layout: 'will_style/components/email', locals: { title: 'Test' }) { 'body content' }

    expect(rendered).to include('<!doctype html>')
  end

  it 'warns that inline CSS styling will not be applied' do
    allow(Rails.logger).to receive(:warn)

    render(layout: 'will_style/components/email', locals: { title: 'Test' }) { 'body content' }

    expect(Rails.logger).to have_received(:warn).with(/premailer-rails/)
  end

  # The logo is a PNG on purpose: Gmail and Outlook don't render SVG in email.
  # A path the asset pipeline can't resolve falls back to /images/..., which
  # 404s in every consuming app.
  describe 'WILL logo' do
    let(:logo_src) { %r{src="/assets/will-style/logos/master-logos/master-dark-gradient(-\h+)?\.png"} }

    it 'resolves to a pipeline asset in the header by default' do
      render(layout: 'will_style/components/email', locals: { title: 'Test' }) { 'body content' }

      expect(rendered).to match(logo_src)
      expect(rendered).not_to include('/images/')
    end

    it 'resolves to a pipeline asset in the footer when a company logo_url is given' do
      render(layout: 'will_style/components/email',
             locals: { title: 'Test', logo_url: 'https://example.com/logo.png' }) { 'body content' }

      expect(rendered).to include('src="https://example.com/logo.png"')
      expect(rendered).to match(logo_src)
    end
  end
end
