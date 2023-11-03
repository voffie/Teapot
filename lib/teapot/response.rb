# frozen_string_literal: true

require_relative 'color'

class Response
  include ResourceManager
  attr_accessor :body, :status

  def initialize(body, status = 200)
    @protocol = 'HTTP/1.1'
    @body = body
    @status = status
    @cookies = {}

    @header = {
      'Content-Type' => 'text/html; charset=utf-8'
    }
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

    if cookies == ''
      "#{@protocol} #{status}\r\n#{headers}\r\n\r\n#{@body}"
    else
      "#{@protocol} #{status}\r\n#{headers}\r\n#{cookies}\r\n\r\n#{@body}"
    end
  end

  def redirect(location)
    @header['Location'] = location
    change_status(301)
  end

  def print
    puts create_response.green
  end

  def slim(resource, layout = true, locals = {})
    slim(resource, layout, locals)
  end
end
