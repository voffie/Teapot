# frozen_string_literal: true

require 'teapot'

RSpec.describe Teapot::Utils do
  include Teapot::Utils

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
