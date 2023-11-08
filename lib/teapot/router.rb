# frozen_string_literal: true

require 'teapot/response'
require 'teapot/resourceManager'

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

  def handleMethod(data)    
    case data[:method]
    when 'GET'
      route = @get_routes.find {|route| route[:regex].match(data[:resource])}
      if !route
        # Handles css
        if data[:Accept].include?('text/css')
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
        end
      else
        paramsValue = data[:resource].split('/').reject(&:empty?)
        route[:params].keys().each_with_index do |key, index|
          route[:params][key] = paramsValue[index]
        end
        params = route[:params].select {|k| k.start_with?(':')}
        request = {params: params}
        request.merge!(data)
        response = Response.new('')
        response.change_content_type('text/html; charset=utf-8')
        route[:code].call(request, response)
      end
    when 'POST'
      route = @post_routes.find {|route| route[:regex].match(data[:resource])}
      if !route
        response = Response.new('Not found', 404)
      end
    when 'PUT'
      route = @put_routes.find {|route| route[:regex].match(data[:resource])}
      if !route
        response = Response.new('Not found', 404)
      end
    when 'DELETE'
      route = @delete_routes.find {|route| route[:regex].match(data[:resource])}
      if !route
        response = Response.new('Not found', 404)
      end
    when 'PATCH'
      route = @patch_routes.find {|route| route[:regex].match(data[:resource])}
      if !route
        response = Response.new('Not found', 404)
      end
    end

    if response.nil?
      response = Response.new('Not implemented yet', 200)
    end
    return response.create_response.to_s
  end
end
