require 'teapot'

port = 4567
server = Teapot.new(port)

server.get('/') do |req, res|
  res.body = File.read('views/index.html')
end

server.listen(lambda { puts "Example app listening on port #{port}" })
