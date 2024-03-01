require 'teapot'

server = Teapot.new()
port = 4567

server.get('/') do |req, res|
  res.redirect('/redirect')
end

server.get('/redirect') do |req, res|
  res.body = "I got redirected here"
end

server.listen(port, lambda { puts "Example app listening on port #{port}" })
