# frozen_string_literal: true

require 'teapot/response'

class Router
  attr_accessor :get_routes, :post_routes, :put_routes, :delete_routes, :patch_routes

  def initialize
    @get_routes = {}
    @post_routes = {}
    @put_routes = {}
    @delete_routes = {}
    @patch_routes = {}
  end

  def handleMethod(data)
    case data[:method]
    when 'GET'
      if @get_routes[data[:resource].to_s].nil?
        response = Response.new('Error', 404)
      end
    when 'POST'
      if @post_routes[data[:resource].to_s].nil?
        response = Response.new('Error', 404)
      end
    when 'PUT'
      if @put_routes[data[:resource].to_s].nil?
        response = Response.new('Error', 404)
      end
    when 'DELETE'
      if @delete_routes[data[:resource].to_s].nil?
        response = Response.new('Error', 404)
      end
    when 'PATCH'
      if @patch_routes[data[:resource].to_s].nil?
        response = Response.new('Error', 404)
      end
    end

    return response.create_response.to_s
  end

end
