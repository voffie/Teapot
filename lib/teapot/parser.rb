# frozen_string_literal: true

VALID_METHODS = %w[GET POST PUT DELETE PATCH].freeze

# Parser module to parse HTTP requests
module Parser
  def parse(request)
    request = request.split("\n")
    return nil if request[0].nil?

    method, resource, http = request[0].split
    parsed_request = {}
    if VALID_METHODS.include? method
      parsed_request[:method] = method
      parsed_request[:resource] = resource
      parsed_request[:http] = http
      request[1..].each do |row|
        key, val = row.split(': ')
        parsed_request[key.gsub('-', '_').to_sym] = val
      end
    else
      parsed_request[:error] = "Invalid method found in request! #{method} is not a valid method!"
    end
    parsed_request
  end
end
