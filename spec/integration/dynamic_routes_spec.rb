# frozen_string_literal: true

require 'teapot/response'
require 'teapot/main'

RSpec.describe 'Dynamic Routes Integration' do
  before do
    @server = Teapot.new(4568)
    @server.get('/params/:id/:name') do |request, response|
      response.body = "Hello #{request[:params][:id]} #{request[:params][:name]}"
      response
    end
  end

  after do
    @server.close
  end

  it 'handles dynamic routes correctly' do
    request = { method: 'GET', resource: '/params/123/456' }
    response = @server.route_request(request)

    expect(response.status).to eq(200)
    expect(response.body).to eq('Hello 123 456')
  end

  it 'returns 404 for unmatched routes' do
    request = { method: 'GET', resource: '/params/123' }
    response = @server.route_request(request)

    expect(response.status).to eq(404)
  end
end
