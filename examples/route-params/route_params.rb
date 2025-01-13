require 'teapot'

port = 4567
server = Teapot.new(port)

server.get('/params/:is/:awesome') do |req, res|
  p req[:params][':awesome']
  res.body = req[:params]
end

server.listen(-> { puts "Example app listening on port #{port}" })
