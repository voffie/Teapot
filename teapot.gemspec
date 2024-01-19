# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'Teapot'
  s.summary = "A web server using Ruby's built-in TCPServer class & web sockets"
  s.author = 'VoffieDev'
  s.homepage = 'https://github.com/voffiedev/teapot'
  s.license = 'MIT'
  s.files = Dir['lib/**/*', ] + ['Gemfile', 'teapot.gemspec']
  s.version = '0.0.0'
  s.metadata = { 'source_code_uri' => 'https://github.com/voffiedev/teapot' }
  s.required_ruby_version = '>= 2.7.8'
end
