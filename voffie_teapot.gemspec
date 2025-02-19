# frozen_string_literal: true

require_relative 'lib/voffie_teapot/version'

Gem::Specification.new 'voffie_teapot', VoffieTeapot::VERSION do |s|
  s.description = "A web server using Ruby's built-in TCPServer class & web sockets"
  s.summary = 'TCP based web server'
  s.author = 'Voffie'
  s.homepage = 'https://github.com/voffie/teapot'
  s.license = 'MIT'
  s.files = Dir['lib/**/*', 'voffie_teapot/views/**/*']
  s.require_paths = ['lib']
  s.metadata = {
    'source_code_uri' => 'https://github.com/voffie/teapot',
    'bug_tracker_uri' => 'https://github.com/voffie/teapot/issues'
  }
  s.required_ruby_version = '>= 2.7.8'

  s.add_dependency 'slim', '~> 5.2', '>= 5.2.1'
end
