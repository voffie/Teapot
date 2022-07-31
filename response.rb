require_relative 'color'

# Generates HTTP Response
class Response
  attr_accessor :body, :status

  def initialize(body, status = 200)
    @protocol = 'HTTP/1.1'
    @body = body
    @status = status

    @header = {
      'Content-Type' => 'text/html; charset=utf-8'
    }
  end

  def create_response
    headers = @header.to_a.map do |key, value|
      "#{key}: #{value}"
    end.join("\r\n")

    "#{@protocol} #{status}\r\n#{headers}\r\n\r\n#{@body}"
  end

  def change_content_type(type)
    @header['Content-Type'] = type
  end

  def change_content_length(length)
    @header['Content-Length'] = length.to_s
  end

  def print
    puts create_response.green
  end
end
