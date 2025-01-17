require 'teapot'

port = 4567
server = Teapot.new(port)

server.get('/') do |_req, res|
  res.create_cookie('teapotExample', 'cookie')
  res.body = 'This page has cookies!'
end

server.listen
