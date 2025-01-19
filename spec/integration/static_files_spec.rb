# frozen_string_literal: true

require 'teapot/resource_manager'
require 'teapot/main'
require 'fileutils'

RSpec.describe 'Static Files Integration' do
  before do
    FileUtils.mkdir_p('./public')
    File.write('./public/styles.css', 'body { background: #fff; }')
    @server = Teapot.new(4567)
  end

  after do
    FileUtils.rm_rf('/public')
    @server.close
  end

  it 'returns CSS content when requested' do
    request = { method: 'GET', resource: '/styles.css', Accept: 'text/css' }
    response = @server.route_request(request)

    expect(response.status).to eq(200)
    expect(response.body).to eq('body { background: #fff; }')
  end

  it 'returns a 404 when a static file is missing' do
    request = { method: 'GET', resource: '/missing.css', Accept: 'text/css' }
    response = @server.route_request(request)

    expect(response.status).to eq(404)
  end
end
