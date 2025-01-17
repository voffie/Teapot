# frozen_string_literal: true

VALID_METHODS = %w[GET POST PUT DELETE PATCH].freeze

# Parser module to parse HTTP requests
module Parser
  def parse(request)
    lines = request.split("\n")
    return nil if lines[0].nil?

    method, resource, http = lines[0].split
    parsed_request = {}

    if VALID_METHODS.include?(method)
      parsed_request[:method] = method
      parsed_request[:resource] = resource
      parsed_request[:http] = http
      lines[1..].each do |row|
        key, val = row.split(': ', 2)
        next if key.nil? || val.nil?

        parsed_request[key.gsub('-', '_').to_sym] = val.strip
      end
    else
      parsed_request[:error] = "Invalid method: #{method}"
    end
    parsed_request
  rescue StandardError => e
    { error: "Error parsing request: #{e.message}" }
  end
end
