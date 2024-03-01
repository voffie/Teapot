require 'teapot'

server = Teapot.new()
port = 4567

server.get('/') do |req, res|
  res.create_cookie('example', 'cookie')
  res.create_cookie('example2', 'cookie2')
  res.body = "This page has cookies!"
end

server.listen(port, lambda { puts "Example app listening on port #{port}" })
