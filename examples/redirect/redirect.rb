require 'teapot'

port = 4567
server = Teapot.new(port)

server.get('/') do |_req, res|
  res.redirect('/redirect')
end

server.get('/redirect') do |_req, res|
  res.body = 'I got redirected here'
end

server.listen
