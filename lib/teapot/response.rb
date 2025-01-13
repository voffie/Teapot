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
    body = "<!DOCTYPE html>
    <html lang='en'>
      <head>
        <meta charset='UTF-8' />
        <meta
          name='viewport'
          content='width=device-width, initial-scale=1.0'
        />
        <title>Teapot - 404</title>
        <style>
          *,
          *::before,
          *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
          }

          div {
            position: fixed;
            inset: 0px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            background-image: linear-gradient(to bottom, #151515, #171717);
            color: white;
            gap: .5rem;
          }

          h1, p {
            z-index: 1;
          }
        </style>
      </head>
      <body>
        <div>
          <h1>Teapot does not recognize this kettle</h1>
          <p>Unkown route #{route}</p>
        </div>
      </body>
    </html>"

    new(404, body)
  end

  def self.default500(error)
    body = "<!DOCTYPE html>
    <html lang='en'>
      <head>
        <meta charset='UTF-8' />
        <meta
          name='viewport'
          content='width=device-width, initial-scale=1.0'
        />
        <title>Teapot - 404</title>
                <style>
          *,
          *::before,
          *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
          }

          div {
            position: fixed;
            inset: 0px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            background-image: linear-gradient(to bottom, #151515, #171717);
            color: white;
            gap: .5rem;
          }

          h1, p {
            z-index: 1;
          }

          p {
            margin-bottom: 2rem;
          }

          code {
            background: #eee;
          }
        </style>
      </head>
      <body>
        <div>
          <h1>Teapot had issues using this kettle</h1>
          <p>#{error.class}: #{error.message}</p>
          <pre>#{error.backtrace}</pre>
        </div>
      </body>
    </html>"

    new(500, body)
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
