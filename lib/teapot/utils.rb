module Utils
  # https://stackoverflow.com/questions/67407289/check-if-path-matches-dynamic-route-string
  def generate_reg_exp(path)
    if path == "/"
      return %r{^/$}
    else
    escape_dots = ->(s) { s.chars.each { |char| char === '.' ? '\\.' : char }.join }
    regex = path.split('/').map { |s| s.start_with?(':') ? '[^\\/]+' : escape_dots.call(s) }
      return Regexp.new("^#{regex.join('\/')}$")
    end
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
end