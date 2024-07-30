# frozen_string_literal: true

require 'teapot/response'
require 'teapot/resource_manager'
require 'teapot/color'

IMG_ENDINGS = %w[apng avif gif jpg jpeg jfif pjpeg pjp png svg webp]

class Router
  attr_accessor :get_routes, :post_routes, :put_routes, :delete_routes, :patch_routes

  include ResourceManager

  def initialize
    @get_routes = []
    @post_routes = []
    @put_routes = []
    @delete_routes = []
    @patch_routes = []
  end

  def handle_method(data, server_middlewares, route_middlewares)
    if server_middlewares.length > 0 && data[:resource].split(".").length == 1
      server_middlewares.each do |middleware|
        begin 
          middleware.call
        rescue => error
          response = Response.new("", 500)
          response.server_error(error)
        end
      end
    end

    if data.nil?
      return
    end

    case data[:method]
    when 'GET'
      current_route = @get_routes.find { |route| route[:regex].match(data[:resource]) }
      if current_route
        current_route_middleware = route_middlewares.select { |middleware| middleware[:regex] == current_route[:regex]}
        
        if current_route_middleware.length > 0
          begin
            current_route_middleware[0][:code].call
          rescue => error
            response = Response.new("", 500)
            response.server_error(error)
          end
        else
          nil
        end

        params_value = data[:resource].split('/').reject(&:empty?)
        current_route[:params].keys.each_with_index do |key, index|
          current_route[:params][key] = params_value[index]
        end
        params = current_route[:params].select { |k| k.start_with?(':') }
        request = { params: params }
        request.merge!(data)
        response = Response.new('')
        response.change_content_type('text/html; charset=utf-8')
        begin
          current_route[:code].call(request, response)
        rescue => error
          response = Response.new("", 500)
          response.server_error(error)
        end

      # Handles css
      elsif data[:Accept] && data[:Accept].include?('text/css')
        value = css(data[:resource])
        response = value[:status] === 200 ? Response.new(value[:content]) : Response.new('Not found', 404)
        response.change_content_type('text/css')

      # Handles imgs
      elsif IMG_ENDINGS.include?(data[:resource].split('.')[1].to_s)
        value = load_img(data[:resource])
        response = value[:status] === 200 ? Response.new(value[:file]) : Response.new('Not found', 404)
        response.change_content_type(value[:ct])
        response.change_content_length(value[:size])

      # Handles scripts (js/ts currently)
      elsif data[:resource].end_with?('js') || data[:resource].end_with?('ts')
        value = load_script(data[:resource])
        response = value[:status] === 200 ? Response.new(value[:content]) : Response.new('Not found', 404)
        response.change_content_type('*/*')
      else
        puts "#{"Warning!".red} Teapot do not recognize the route #{data[:resource].yellow} !"
        response = Response.new("", 404)
        response.not_found(data[:resource])
      end

    when 'POST'
      current_route = @post_routes.find { |route| route[:regex].match(data[:resource]) }
      if current_route
        params_value = data[:resource].split('/').reject(&:empty?)
        current_route[:params].keys.each_with_index do |key, index|
          current_route[:params][key] = params_value[index]
        end
        params = current_route[:params].select { |k| k.start_with?(':') }
        request = { params: params }
        request.merge!(data)
        response = Response.new('')
        begin
          current_route[:code].call(request, response)
        rescue => error
          response = Response.new("", 500)
          response.server_error(error)
        end
      else
        response = Response.new("", 404)
        response.not_found(data[:resource])
      end

    when 'PUT'
      current_route = @put_routes.find { |route| route[:regex].match(data[:resource]) }
      if current_route
        params_value = data[:resource].split('/').reject(&:empty?)
        current_route[:params].keys.each_with_index do |key, index|
          current_route[:params][key] = params_value[index]
        end
        params = current_route[:params].select { |k| k.start_with?(':') }
        request = { params: params }
        request.merge!(data)
        response = Response.new('')
        begin
          current_route[:code].call(request, response)
        rescue => error
          response = Response.new("", 500)
          response.server_error(error)
        end
      else
        response = Response.new("", 404)
        response.not_found(data[:resource])
      end

    when 'DELETE'
      current_route = @delete_routes.find { |route| route[:regex].match(data[:resource]) }
      if current_route
        params_value = data[:resource].split('/').reject(&:empty?)
        current_route[:params].keys.each_with_index do |key, index|
          current_route[:params][key] = params_value[index]
        end
        params = current_route[:params].select { |k| k.start_with?(':') }
        request = { params: params }
        request.merge!(data)
        response = Response.new('')
        begin
          current_route[:code].call(request, response)
        rescue => error
          response = Response.new("", 500)
          response.server_error(error)
        end
      else
        response = Response.new("", 404)
        response.not_found(data[:resource])
      end

    when 'PATCH'
      current_route = @patch_routes.find { |route| route[:regex].match(data[:resource]) }
      if current_route
        params_value = data[:resource].split('/').reject(&:empty?)
        current_route[:params].keys.each_with_index do |key, index|
          current_route[:params][key] = params_value[index]
        end
        params = current_route[:params].select { |k| k.start_with?(':') }
        request = { params: params }
        request.merge!(data)
        response = Response.new('')
        begin
          current_route[:code].call(request, response)
        rescue => error
          response = Response.new("", 500)
          response.server_error(error)
        end
      else
        response = Response.new("", 404)
        response.not_found(data[:resource])
      end
    end

    if response.nil?
      response = Response.new("", 404)
    end

    response.create_response.to_s
  end
end
