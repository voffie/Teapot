# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'teapot'
  s.summary = "A web server using Ruby's built-in TCPServer class & web sockets"
  s.description = s.summary
  s.author = 'Voffie'
  s.homepage = 'https://github.com/voffie/teapot'
  s.license = 'MIT'
  s.files = Dir['lib/**/*', 'teapot/views/**/*']
  s.require_paths = ['lib']
  s.version = '0.0.0'
  s.metadata = {
    'source_code_uri' => 'https://github.com/voffie/teapot',
    'rubygems_mfa_required' => 'true',
    'bug_tracker_uri' => 'https://github.com/voffie/teapot/issues'
  }
  s.required_ruby_version = '>= 2.7.8'

  s.add_dependency 'slim', '~> 5.2', '>= 5.2.1'
end
