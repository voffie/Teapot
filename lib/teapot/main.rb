# frozen_string_literal: true

require 'socket'
require 'json'
require 'teapot/parser'
require 'teapot/http_handler'
require 'teapot/get_handler'
require 'teapot/post_handler'

# Base class for Teapot gem
class Teapot
  include Parser
  attr_reader :server

  def initialize(port)
    @server = TCPServer.new(port)
    @routes = { 'GET' => [], 'POST' => [] }
  end

  def listen
    puts "Teapot server started. Listening on port #{@server.addr[1]}..."

    loop do
      socket = @server.accept

      Thread.new do
        request = ''

        while (line = socket.gets) && line !~ /^\s*$/
          request += line
        end
  def get(path, &block)
    @routes['GET'] << GetHandler.new(path, block)
  end

        next if request == ''
  def post(path, &block)
    @routes['POST'] << PostHandler.new(path, block)
  end

        parsed_request = parse(request)

        if parsed_request[:Content_Length].to_i.positive?
          parsed_request[:body] = JSON.parse(socket.read(parsed_request[:Content_Length].to_i))
          parsed_request[:body] = parsed_request[:body].transform_keys(&:to_sym)
        end

        response = handle_request(parsed_request)

        socket.print response
        socket.close
      end
    end
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
