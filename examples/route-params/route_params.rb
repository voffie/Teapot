require 'teapot'

port = 4567
server = Teapot.new(port)

server.get('/params/:is/:awesome') do |req, res|
  res.body = req[:params]
end

server.listen
