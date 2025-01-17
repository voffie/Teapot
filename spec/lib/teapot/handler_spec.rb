# frozen_string_literal: true

require 'teapot/http_handler'

RSpec.describe HTTPHandler do
  let(:handler) { HTTPHandler.new('/params/:is/:awesome') }

  describe '#matches?' do
    it 'returns true for matching routes' do
      expect(handler.matches?('/params/123/456')).to be(true)
    end

    it 'returns false for non-matching routes' do
      expect(handler.matches?('/params/123')).to be(false)
    end
  end

  describe '#extract_params' do
    it 'extracts parameters correctly' do
      result = handler.extract_params('/params/123/456')
      expect(result).to eq({ is: '123', awesome: '456' })
    end

    it 'returns an empty hash for non-matching routes' do
      result = handler.extract_params('/params/123')
      expect(result).to eq({})
    end
  end
end
