# frozen_string_literal: true

require 'socket'
require 'json'
require 'teapot/parser'
require 'teapot/response'
require 'teapot/http_handler'
require 'teapot/get_handler'
require 'teapot/post_handler'

module Teapot
  # Base class for Teapot gem
  class Main
    include Parser

    def initialize(port)
      @server = TCPServer.new(port)
      @running = true
      @routes = { 'GET' => [], 'POST' => [] }
      @middleware = []

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

    def use(path, &middleware)
      @middleware << { path: path, middleware: middleware }
    end

    def process_middleware(request, response)
      matching_middleware = @middleware.select { |m| match_route(m[:path], request[:resource]) }

      matching_middleware.each do |middleware|
        res = middleware[:middleware].call(request, response)
        p res
        return res if res.is_a?(Response)
      end
    end

    def match_route(route, resource)
      return true if route == '*'

      route_segments = route.split('/')
      resource_segments = resource.split('/')

      return false if route_segments.length != resource_segments.length

      route_segments.each_with_index do |_segments, index|
        if segment.start_with?(':')
          next
        elsif segment != resource_segments[index]
          return false
        end
      end

      true
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
      response = Response.new
      process_middleware(request, response)

      return response unless response.body == ''

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
end
