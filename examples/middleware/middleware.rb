require 'teapot'

port = 4567
server = Teapot.new(port)

server.use('/') do |req, _res|
  # Updates the locals symbol of the incoming request
  req[:locals] = Time.now
end

server.get('/') do |req, res|
  template = File.read('views/index.html')

  # Populating the response with the value set in the middleware
  template.gsub!('<%= middleware_header %>', req[:locals].to_s)

  res.body = template
end

server.listen
