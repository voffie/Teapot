# frozen_string_literal: true

require 'voffie_teapot'

RSpec.describe 'Error Page Integration' do
  describe '404 Error Page' do
    it 'renders the custom 404 page when a route is not found' do
      result = VoffieTeapot::Response.default404('/unknown/path')
      expect(result.status).to eq(404)
      expect(result.body).to include('404 - Not Found')
    end

    it 'uses a fallback 404 template if the custom page is missing' do
      allow(File).to receive(:read).and_raise(Errno::ENOENT)
      result = VoffieTeapot::Response.default404('/fallback/test')
      expect(result.body).to include('Error loading template')
    end
  end

  describe '500 Error Page' do
    it 'renders the custom 500 page when an error occurs' do
      error = StandardError.new('Internal Server Error')
      result = VoffieTeapot::Response.default500(error)
      expect(result.status).to eq(500)
      expect(result.body).to include('500 - Internal Server Error')
    end

    it 'uses a fallback 500 template if the custom page is missing' do
      allow(File).to receive(:read).and_raise(Errno::ENOENT)
      result = VoffieTeapot::Response.default500(StandardError.new('Fallback test'))
      expect(result.body).to include('Error loading template')
    end
  end
end
