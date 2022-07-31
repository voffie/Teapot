require 'socket'
require_relative 'color'
require_relative 'parser'
require_relative 'router'

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

      end
    end
  end

  def get(path, &block)
    @router.get_routes[path] = block
  end
end
