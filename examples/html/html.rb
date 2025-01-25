require 'teapot'

port = 4567
server = Teapot.new(port)

server.get('/') do |_req, res|
  # Reading HTML file and setting it as the response body
  res.body = File.read('views/index.html')
end

server.listen
