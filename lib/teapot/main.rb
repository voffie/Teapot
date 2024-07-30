# frozen_string_literal: true

require 'socket'
require 'json'
require 'teapot/parser'
require 'teapot/router'

class Teapot
  include Parser
  attr_reader :server

  def initialize
    @router = Router.new
    @server_middlewares = []
    @route_middlewares = []
  end

  def listen(port, option)
    server = TCPServer.new(port)
    option.call
    while (session = server.accept)
      data = ''
      while (line = session.gets) && line !~ /^\s*$/
        data += line
      end
      parsed_data = parse(data)
      if parsed_data[:Content_Length].to_i > 0
        parsed_data[:body] = JSON.parse(session.read(parsed_data[:Content_Length].to_i))
        parsed_data[:body] = parsed_data[:body].transform_keys(&:to_sym)
      end
      response = @router.handle_method(parsed_data, @server_middlewares, @route_middlewares)
      session.print response
      session.close
    end
  end

  def get(path, &block)
    parsed_params = get_params_from_path(path)
    regex = path === '/' ? %r{^/$} : generate_reg_exp(path)
    @router.get_routes.push({ path: path, regex: regex, code: block, params: parsed_params })
  end

  def post(path, &block)
    parsed_params = get_params_from_path(path)
    regex = path === '/' ? %r{^/$} : generate_reg_exp(path)
    @router.post_routes.push({ path: path, regex: regex, code: block, params: parsed_params })
  end

  def put(path, &block)
    parsed_params = get_params_from_path(path)
    regex = path === '/' ? %r{^/$} : generate_reg_exp(path)
    @router.put_routes.push({ path: path, regex: regex, code: block, params: parsed_params })
  end

  def delete(path, &block)
    regex = generate_reg_exp(path)
    @router.delete_routes.push({ path: path, regex: regex, code: block })
  end

  def patch(path, &block)
    regex = generate_reg_exp(path)
    @router.patch_routes.push({ path: path, regex: regex, code: block })
  end

  def use_middleware(path, &block)
    regex = path === '/' ? %r{^/$} : generate_reg_exp(path)
    @route_middlewares.push({ path: path, regex: regex, code: block })
  end

  def before(block)
    @server_middlewares.push(block)
  end
end

# https://stackoverflow.com/questions/67407289/check-if-path-matches-dynamic-route-string
def generate_reg_exp(path)
  escape_dots = ->(s) { s.chars.each { |char| char === '.' ? '\\.' : char }.join }
  regex = path.split('/').map { |s| s.start_with?(':') ? '[^\\/]+' : escape_dots.call(s) }
  Regexp.new("^#{regex.join('\/')}$")
end

def get_params_from_path(path)
  params = path.split('/').reject(&:empty?)
  parsed_params = {}
  unless params.empty?
    params.each do |param|
      parsed_params[param] = ''
    end
  end
  parsed_params
end
