require 'voffie_teapot'

port = 4567
server = VoffieTeapot.new(port)

server.get('/') do |_req, res|
  # Creates a cookie called 'teapot-example'
  res.create_cookie('teapot-example', 'cookie')
  res.body = File.read('views/index.html')
end

server.listen
