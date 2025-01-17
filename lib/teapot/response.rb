# frozen_string_literal: true

require 'teapot/color'
require 'teapot/resource_manager'

# Response class to handle/generate responses
class Response
  include ResourceManager
  attr_accessor :body, :status

  def initialize(status = 200, body = '', header = {})
    @status = status
    @body = body
    @header = header
    @cookies = {}
  end

  def self.default404(route)
    body = load_error_page('404.html', { route: route })
    new(404, body, { 'Content-Type' => 'text/html' })
  end

  def self.default500(error)
    body = load_error_page('500.html', { error_message: error.message, error_class: error.class, backtrace: error.backtrace })
    new(500, body, { 'Content-Type' => 'text/html' })
  end

  def self.load_error_page(filename, locals = {})
    user_path = "./views/#{filename}"
    gem_path = File.join(Gem::Specification.find_by_name('teapot').gem_dir, 'lib', 'teapot', 'views', filename)

    if File.exist?(user_path)
      template = File.read(user_path)
    else
      return '<html><body><h1>Error loading template</h1></body></html>' unless File.exist?(gem_path)

      template = File.read(gem_path)
    end

    locals.each do |key, value|
      template.gsub!("<%= #{key} %>", value.to_s)
    end

    template
  rescue Errno::ENOENT
    '<html><body><h1>Error loading template</h1></body></html>'
  end

  def create_cookie(name, value)
    @cookies[name] = value
  end

  def change_status(status)
    @status = status
  end

  def change_content_type(type)
    @header['Content-Type'] = type
  end

  def change_content_length(length)
    @header['Content-Length'] = length.to_s
  end

  def create_response
    headers = @header.to_a.map do |key, value|
      "#{key}: #{value}"
    end.join("\r\n")

    cookies = @cookies.to_a.map do |key, value|
      "Set-Cookie: #{key}=#{value}"
    end.join("\r\n")

    return "HTTP/1.1 #{status}\r\n#{headers}\r\n\r\n#{@body}" if cookies == ''

    "HTTP/1.1 #{status}\r\n#{headers}\r\n#{cookies}\r\n\r\n#{@body}"
  end

  def redirect(location)
    @header['Location'] = location
    change_status(301)
  end

  def print
    puts create_response.green
  end

  def slim(resource, locals = {}, layout: true)
    load_slim(resource, locals, layout: layout)
  end
end
