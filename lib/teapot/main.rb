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
    parsed_params = get_params_from_path(path)
    regex = path === '/' ? %r{^/$} : generate_reg_exp(path)
    @router.delete_routes.push({ path: path, regex: regex, code: block, params: parsed_params })
  end

  def patch(path, &block)
    parsed_params = get_params_from_path(path)
    regex = path === '/' ? %r{^/$} : generate_reg_exp(path)
    @router.patch_routes.push({ path: path, regex: regex, code: block, params: parsed_params })
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
