require 'teapot'

server = Teapot.new()
port = 4567

server.get('/params/:is/:awesome') do |req, res|
  p req[:params]["awesome"]
  res.body = req[:params]
end

server.listen(port, lambda { puts "Example app listening on port #{port}" })
