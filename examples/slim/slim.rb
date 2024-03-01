require 'teapot'

server = Teapot.new()
port = 4567

server.get('/') do |req, res|
  res.body = res.slim(:index)
end

server.listen(port, lambda { puts "Example app listening on port #{port}" })
