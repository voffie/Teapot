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
    end

    response =
      case request[:method]
      when 'GET'
        handle_get_request(request, current_route)
      when 'POST'
        handle_post_request(request, current_route)
      end

    if response.nil?
      puts "#{'Warning!'.red} Teapot do not recognize the route #{request[:resource].yellow} !"
      response = Response.default404(request[:resource])
    end

    response.create_response.to_s
  end

  def handle_get_request(request, current_route)
    if current_route
      response = Response.new
      response.change_content_type('text/html; charset=utf-8')
      begin
        current_route[:code].call(request, response)
      rescue StandardError => e
        Response.default500(e)
      end

    # Handles css
    elsif request[:Accept]&.include?('text/css')
      Response.new
      value = css(request[:resource])
      response = value[:status] == 200 ? Response.new(200, value[:content]) : Response.default404(request[:resource])
      response.change_content_type('text/css')

    # Handles imgs
    elsif IMG_ENDINGS.include?(request[:resource].split('.')[1].to_s)
      value = load_img(request[:resource])
      if value[:status] == 200
        response = Response.new(200, value[:file])
        response.change_content_type(value[:ct])
        response.change_content_length(value[:size])
      else
        response = Response.default404(request[:resource])
      end

    # Handles scripts (js/ts currently)
    elsif request[:resource].end_with?('js') || request[:resource].end_with?('ts')
      value = load_script(request[:resource])
      if value[:status] == 200
        response = Response.new(200, value[:content])
        response.change_content_type('*/*')
      else
        Response.default404(request[:resource])
      end
    end

    response
  end

  def handle_post_request(request, current_route)
    response = Response.new
    return unless current_route

    begin
      current_route[:code].call(request, response)
    rescue StandardError => e
      Response.default500(e)
    end

    response
  end
end
