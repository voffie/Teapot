# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'Teapot'
  s.version = '0.0.0'
  s.author = 'VoffieDev'
  s.summary = "A web server using Ruby's built-in TCPServer class & web sockets"
  s.files = ['lib/teapot.rb', 'lib/teapot/main.rb', 'lib/teapot/parser.rb', 'lib/teapot/response.rb', 'lib/teapot/router.rb', 'lib/teapot/color.rb', 'lib/teapot/resourceManager.rb']
  s.metadata = { 'source_code_uri' => 'https://github.com/voffiedev/teapot' }
  s.required_ruby_version = '>= 2.7.0'
  s.license = nil
  s.homepage = 'https://github.com/voffiedev/teapot'
end
