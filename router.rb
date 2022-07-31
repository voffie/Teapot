# Storing  of post & get routes
class Router
  attr_accessor :get_routes

  def initialize
    @get_routes = {}
  end
end