# frozen_string_literal: true

require 'socket'
require 'json'
require 'teapot/parser'
require 'teapot/response'
require 'teapot/http_handler'
require 'teapot/get_handler'
require 'teapot/post_handler'

# Base class for Teapot gem
class Teapot
  include Parser

  def initialize(port)
    @server = TCPServer.new(port)
    @running = true
    @routes = { 'GET' => [], 'POST' => [] }

    Signal.trap('INT') do
      puts "\nShutting down server..."
      close
    end
  end

  def close
    @running = false
    @server.close
  end

  def listen
    puts "Teapot server started. Listening on port #{@server.addr[1]}..."

    while @running
      socket = @server.accept
      Thread.new { handle_connection(socket) }
    end
  end

  def get(path, &block)
    @routes['GET'] << GetHandler.new(path, block)
  end

  def post(path, &block)
    @routes['POST'] << PostHandler.new(path, block)
  end

  def handle_connection(socket)
    request = read_request(socket)
    return unless request

    parsed_request = parse(request)
    if parsed_request[:Content_Length].to_i.positive?
      parsed_request[:body] = JSON.parse(socket.read(parsed_request[:Content_Length].to_i))
      parsed_request[:body] = parsed_request[:body].transform_keys(&:to_sym)
    end

    response = route_request(parsed_request).create_response
    socket.print response
    socket.close
  end

  def read_request(socket)
    request = ''
    while (line = socket.gets) && line !~ /^\s*$/
      request += line
    end
    request.empty? ? nil : request
  end

  def route_request(request)
    method = request[:method]
    return Response.default404(request[:path]) unless @routes.key?(method)

    handler = @routes[method].find { |h| h.matches?(request[:resource]) }
    if handler
      response = handler.handle(request)
      return response.is_a?(Response) ? response : Response.default404(request[:path])
    end

    response =
      case method
      when 'GET'
        GetHandler.new(nil).handle(request)
      when 'POST'
        PostHandler.new(nil).handle(request)
      end

    response.is_a?(Response) ? response : Response.default404(request[:path])
  end
end
