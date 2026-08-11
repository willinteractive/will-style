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
end
