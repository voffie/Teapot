# frozen_string_literal: true

require 'voffie_teapot/utils'

module VoffieTeapot
  # Abstract class for HTTP method handlers
  class HTTPHandler
    include Utils

    def initialize(path, block = nil)
      @path = path
      @regex = generate_reg_exp(path) if path
      @block = block
      @param_names = extract_param_names(path)
    end

    def matches?(path)
      return false unless @regex

      @regex.match?(path)
    end

    def extract_params(resource)
      return {} unless resource.is_a?(String) && @path.is_a?(String)

      param_names = extract_param_names(resource)
      match_data = @regex.match(resource)

      return {} unless param_names.any? && match_data

      @param_names.zip(match_data.captures).to_h
    end

    def handle(request)
      raise NotImplementedError, 'You must implement the `handle` method in a subclass.'
    end

    private

    def extract_param_names(resource)
      return [] unless resource.is_a?(String) && @path.is_a?(String)

      path_segments = @path.split('/')
      resource_segments = resource.split('/')

      return [] if path_segments.size != resource_segments.size

      path_segments.select { |segment| segment.start_with?(':') }.map { |param| param[1..].to_sym }
    end
  end
end
