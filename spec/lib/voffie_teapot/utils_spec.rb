# frozen_string_literal: true

require 'voffie_teapot'

RSpec.describe VoffieTeapot::Utils do
  include VoffieTeapot::Utils

  describe '#generate_reg_exp' do
    it 'creates a regex for dynamic routes' do
      regex = generate_reg_exp('/params/:id/:name')
      expect(regex).to eq(%r{^/params/([^/]+)/([^/]+)$})
    end

    it 'creates a regex for static routes' do
      regex = generate_reg_exp('/static/path')
      expect(regex).to eq(%r{^/static/path$})
    end
  end
end
