require 'teapot'

port = 4567
server = Teapot.new(port)

server.get('/') do |req, res|
  res.redirect('/redirect')
end

server.get('/redirect') do |req, res|
  res.body = "I got redirected here"
end

server.listen(lambda { puts "Example app listening on port #{port}" })
