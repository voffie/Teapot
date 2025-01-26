# frozen_string_literal: true

module VoffieTeapot
  # POST implementation of HTTPHandler
  class PostHandler < HTTPHandler
    def handle(request)
      return unless matches?(request[:resource])

      response = Response.new
      begin
        @block.call(request, response)
      rescue StandardError => e
        return Response.default500(e)
      end
      response
    end
  end
end
