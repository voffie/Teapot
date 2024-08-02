# frozen_string_literal: true

require 'teapot/utils'
require 'teapot/response'
require 'teapot/resource_manager'
require 'teapot/color'

IMG_ENDINGS = %w[apng avif gif jpg jpeg jfif pjpeg pjp png svg webp]

module Router
  include ResourceManager, Utils
  
  @@routes = []

  def generate_route(path, type, block)
    parsed_params = get_params_from_path(path)
    regex = generate_reg_exp(path)
    @@routes.push({ path: path, regex: regex, code: block, params: parsed_params, type: type })
  end

  def handle_request(request)
    current_route = @@routes.find { |route| route[:regex].match(request[:resource]) && route[:type] == request[:method]}

    if current_route
      params_value = request[:resource].split('/').reject(&:empty?)
      current_route[:params].keys.each_with_index do |key, index|
        current_route[:params][key] = params_value[index]
      end
      params = current_route[:params].select { |k| k.start_with?(':') }
      params = { params: params }
      request.merge!(params)
      response = Response.new('')
    end

    case request[:method]
    when 'GET'
      if current_route
        response.change_content_type('text/html; charset=utf-8')
        begin
          current_route[:code].call(request, response)
        rescue => error
          response = Response.new("", 500)
          response.server_error(error)
        end

      # Handles css
      elsif request[:Accept] && request[:Accept].include?('text/css')
        value = css(request[:resource])
        response = value[:status] === 200 ? Response.new(value[:content]) : Response.new('Not found', 404)
        response.change_content_type('text/css')

      # Handles imgs
      elsif IMG_ENDINGS.include?(request[:resource].split('.')[1].to_s)
        value = load_img(request[:resource])
        response = value[:status] === 200 ? Response.new(value[:file]) : Response.new('Not found', 404)
        response.change_content_type(value[:ct])
        response.change_content_length(value[:size])

      # Handles scripts (js/ts currently)
      elsif request[:resource].end_with?('js') || request[:resource].end_with?('ts')
        value = load_script(request[:resource])
        response = value[:status] === 200 ? Response.new(value[:content]) : Response.new('Not found', 404)
        response.change_content_type('*/*')
      end

    when 'POST'
      if current_route
        begin
          current_route[:code].call(request, response)
        rescue => error
          response = Response.new("", 500)
          response.server_error(error)
        end
      end
    end

    if response.nil?
      puts "#{"Warning!".red} Teapot do not recognize the route #{request[:resource].yellow} !"
      response = Response.new("", 404)
      response.not_found(request[:resource])
    end

    response.create_response.to_s
  end
end
