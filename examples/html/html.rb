require 'teapot'

server = Teapot.new()
port = 4567

server.get('/') do |req, res|
  res.body = File.read('views/index.html')
end

server.listen(port, lambda { puts "Example app listening on port #{port}" })
