require 'voffie_teapot'

port = 4567
server = VoffieTeapot.new(port)

server.get('/') do |_req, res|
  # Reading HTML file and setting it as the response body
  res.body = File.read('views/index.html')
end

server.listen
