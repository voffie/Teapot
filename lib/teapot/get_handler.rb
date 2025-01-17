# frozen_string_literal: true

require 'teapot/response'
require 'teapot/resource_manager'

# GET implementation of HTTPHandler
class GetHandler < HTTPHandler
  include ResourceManager

  def handle(request)
    if matches?(request[:resource])
      route_params = extract_params(request[:resource])
      request[:params] = route_params

      response = Response.new
      response.change_content_type('text/html; charset=utf-8')
      begin
        @block.call(request, response)
        return response
      rescue StandardError => e
        return Response.default500(e)
      end
    end

    handle_static_resource(request)
  end

  private

  def handle_static_resource(request)
    if request[:Accept]&.include?('text/css')
      handle_css(request)
    elsif IMG_CONTENT_TYPES.keys.include?(request[:resource].split('.').last.to_sym)
      handle_image(request)
    elsif request[:resource].end_with?('.js', '.ts')
      handle_script(request)
    else
      Response.default404(request[:resounce])
    end
  end

  def handle_css(request)
    value = css(request[:resource])
    if value[:status] == 200
      Response.new(200, value[:file], { 'Content-Type' => 'text/css' })
    else
      Response.default404(request[:resource])
    end
  end

  def handle_image(request)
    value = load_img(request[:resource])
    if value[:status] == 200
      response = Response.new(200, value[:file])
      response.change_content_type(value[:ct])
      response.change_content_length(value[:size])
      response
    else
      Response.default404(request[:resource])
    end
  end

  def handle_script(request)
    value = load_script(request[:resource])
    if value[:status] == 200
      Response.new(200, value[:file], { 'Content-Type' => '*/*' })
    else
      Response.default404(request[:resource])
    end
  end
end
