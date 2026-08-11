# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WillStyle::LibraryHelpers, type: :helper do
  describe '#icon' do
    it 'renders a Font Awesome icon tag' do
      html = helper.icon('fas', 'check').to_s

      expect(html).to eq('<i class="fas fa-check" aria-hidden="true"></i>')
    end

    it 'appends extra classes without clobbering the icon classes' do
      html = helper.icon('fas', 'check', class: 'text-success').to_s

      expect(html).to include('class="fas fa-check text-success"')
    end

    it 'appends trailing text after the icon' do
      html = helper.icon('fas', 'check', 'Done').to_s

      expect(html).to end_with(' Done')
    end

    it 'does not treat an html_options hash passed as the third argument as text' do
      html = helper.icon('fas', 'check', class: 'ms-2').to_s

      expect(html).not_to include('>ms-2')
    end
  end
end
