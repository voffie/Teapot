require 'teapot/response'

RSpec.describe Response do
  describe '.default404' do
    it 'returns a 404 response with the correct body' do
      response = Response.default404('/nonexistent')
      expect(response.status).to eq(404)
      expect(response.body).to include('404 - Not Found')
    end
  end

  describe '.default500' do
    it 'returns a 500 response with the error message' do
      error = StandardError.new('Something went wrong')
      response = Response.default500(error)
      expect(response.status).to eq(500)
      expect(response.body).to include('Something went wrong')
    end
  end

  describe '.load_error_page' do
    context 'when the file exists' do
      it 'returns the contents of the file with interpolated locals' do
        allow(File).to receive(:read).and_return('<h1><%= path %> Not Found</h1>')
        result = Response.load_error_page('404.html', { path: '/test' })
        expect(result).to eq('<h1>/test Not Found</h1>')
      end
    end

    context 'when the file does not exist' do
      it 'returns a default error message' do
        allow(File).to receive(:read).and_raise(Errno::ENOENT)
        result = Response.load_error_page('404.html', { path: '/test' })
        expect(result).to include('Error loading template')
      end
    end
  end
end
