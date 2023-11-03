# frozen_string_literal: true

require 'socket'
require 'teapot/parser'
require 'teapot/router'

class Teapot
  include Parser
  attr_reader :server

  def initialize()
    @router = Router.new
    @img_endings = %w[apng avif gif jpg jpeg jfif pjpeg pjp png svg webp]
  end

  def listen(port, option)
    server = TCPServer.new(port)
    option.call()
    while (session = server.accept)
      data = ''
      while (line = session.gets) && line !~ /^\s*$/
        data += line
      end
      parsed_data = parse(data)
      response = @router.handleMethod(parsed_data)
      session.print response
      session.close
    end
  end

  def get(path, &block)
    @router.get_routes[path] = block
  end

  def post(path, &block)
    @router.post_routes[path] = block
  end

  def put(path, &block)
    @router.put_routes[path] = block
  end

  def delete(path, &block)
    @router.delete_routes[path] = block
  end

  def patch(path, &block)
    @router.patch_routes[path] = block
  end
end
