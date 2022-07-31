require_relative 'color'

VALID_METHODS = %w[GET HEAD POST PUT DELETE CONNECT OPTIONS TRACE PATCH].freeze

class Parser
  attr_reader :parsed_request

  def parse(request)
    request = request.split("\n")
    @parsed_request = {}
    method, resource, http = request[0].split(' ')
    if VALID_METHODS.include? method
      @parsed_request[:method] = method
      @parsed_request[:resource] = resource
      @parsed_request[:http] = http
      request[1..-1].each do |row|
        key, val = row.split(': ')
        @parsed_request[key.gsub('-', '_').to_sym] = val
      end
    else
      @parsed_request[:error] = "Invalid method found in request! #{method} is not a valid method!"
    end
  end

  def print
    puts @parsed_request[:http].blue
    puts @parsed_request[:method].blue
    puts @parsed_request[:resource].blue
    puts @parsed_request[:Accept].blue
  end
end
