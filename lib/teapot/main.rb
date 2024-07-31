# frozen_string_literal: true

require 'socket'
require 'json'
require 'teapot/parser'
require 'teapot/router'

class Teapot
  include Parser, Router
  attr_reader :server

  def initialize(port)
    @server = TCPServer.new(port)
  end

  def listen(setup_func)
    setup_func.call

    loop do
      socket = @server.accept

      Thread.new do
        request = ''

        while line = socket.gets and line !~ /^\s*$/
          request += line
        end

        if request == ''
          next
        end

        parsed_request = parse(request)

        if parsed_request[:Content_Length].to_i > 0
          parsed_request[:body] = JSON.parse(socket.read(parsed_request[:Content_Length].to_i))
          parsed_request[:body] = parsed_request[:body].transform_keys(&:to_sym)
        end

        response = handle_request(parsed_request)
        
        socket.print response
        socket.close
      end
    end
  end

  def get(path, &block)
    generate_route(path, "GET", block)
  end

  def post(path, &block)
    generate_route(path, "POST", block)
  end
end
