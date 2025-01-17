# frozen_string_literal: true

# Module containing all utility methods required
module Utils
  # https://stackoverflow.com/questions/67407289/check-if-path-matches-dynamic-route-string
  def generate_reg_exp(path)
    return %r{^/$} if path == '/'

    escape_dots = ->(s) { s.chars.each { |char| char == '.' ? '\\.' : char }.join }
    regex = path.split('/').map { |s| s.start_with?(':') ? '[^\\/]+' : escape_dots.call(s) }
    Regexp.new("^#{regex.join('\/')}$")
  end
  end
end
