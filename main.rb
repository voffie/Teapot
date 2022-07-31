require 'socket'
require_relative 'color'
require_relative 'parser'
require_relative 'router'
require_relative 'response'

MAX_RESPONSE_LENGTH = 5000

# Handles HTTP responses and returns data accordingly
class Teapot
  attr_reader :server

  def initialize(port = 4567)
    @port = port
    @parser = Parser.new
    @router = Router.new
  end

  def launch
    server = TCPServer.new(@port)
    puts "=== Server is launched on port #{@port} ===".yellow

    while (session = server.accept)
      data = ''
      while (line = session.gets) and line !~ /^\s*$/
        data += line
      end
      @parser.parse(data)
      puts 'Incoming:'
      @parser.print
      parsed_data = @parser.parsed_request

      case parsed_data[:method]
      when 'GET'

        if parsed_data[:Accept].include?('text/css')
          response = Response.new(css(parsed_data[:resource]), 200)
          response.change_content_type('text/css')
        elsif @router.get_routes[parsed_data[:resource].to_s].nil?
          response = Response.new('Error', 404)
        else
          response = Response.new('No body')
          @router.get_routes[parsed_data[:resource].to_s].call(response)
        end
      end

      puts 'Outgoing:'
      if response.create_response.length < MAX_RESPONSE_LENGTH
        response.print
      else
        puts "#{parsed_data[:resource]} as binary".yellow
      end
      session.print response.create_response.to_s
      session.close
    end
  end

  def get(path, &block)
    @router.get_routes[path] = block
  end

  def css(resource)
    if Dir.exist?('./public/css')
      begin
        File.open("./public/css#{resource}").read
      rescue Errno::ENOENT
        p 'CSS-file is not found!'
        ['', 500]
      end
    else
      begin
        content = File.open("./public#{resource}").read
      rescue Errno::ENOENT
        p 'CSS-file is not found!'
        ['', 500]
      end
    end
  end
end
