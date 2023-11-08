# frozen_string_literal: true

require 'socket'
require 'teapot/parser'
require 'teapot/router'

class Teapot
  include Parser
  attr_reader :server

  def initialize()
    @router = Router.new
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
    parsedParams = getParamsFromPath(path)
    regex = path === "/" ? /^\/$/ : generateRegExp(path)
    @router.get_routes.push({path: path, regex: regex, code: block, params: parsedParams})
  end

  def post(path, &block)
    regex = generateRegExp(path)
    @router.post_routes.push({path: path, regex: regex, code: block})
  end

  def put(path, &block)
    regex = generateRegExp(path)
    @router.put_routes.push({path: path, regex: regex, code: block})
  end

  def delete(path, &block)
    regex = generateRegExp(path)
    @router.delete_routes.push({path: path, regex: regex, code: block})
  end

  def patch(path, &block)
    regex = generateRegExp(path)
    @router.patch_routes.push({path: path, regex: regex, code: block})
  end
end

# https://stackoverflow.com/questions/67407289/check-if-path-matches-dynamic-route-string
def generateRegExp(path)
  escapeDots = -> (s) {s.split('').each {|char| char === "." ? '\\.' : char}.join('')}
  regex = path.split("/").map {|s| s.start_with?(':') ? "[^\\/]+" : escapeDots.call(s)}
  return Regexp.new("^#{regex.join('\/')}$")
end

def getParamsFromPath(path)
  params = path.split('/').reject(&:empty?)
  parsedParams = {}
  if params.length != 0
    params.each_with_index do |param, index|
      parsedParams[param] = ""
    end
  end
  return parsedParams
end
