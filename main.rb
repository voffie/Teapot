require 'socket'
require_relative 'color'

class Teapot
  attr_reader :server

  def initialize(port = 4567)
    @port = port
  end

  def launch
    server = TCPServer.new(@port)
    puts "=== Server is launched on port #{@port} ===".yellow

    while (session = server.accept)
      data = ''
      while (line = session.gets) and line !~ /^\s*$/
        data += line
      end
    end
  end
end
