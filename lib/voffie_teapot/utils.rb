# frozen_string_literal: true

module VoffieTeapot
  # Module containing all utility methods required
  module Utils
    def generate_reg_exp(path)
      return %r{^/$} if path == '/'

      Regexp.new("^#{path.split('/').map do |segment|
        segment.start_with?(':') ? '([^/]+)' : Regexp.escape(segment)
      end.join('/')}$")
    end
  end
end
