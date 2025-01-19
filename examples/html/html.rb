require 'teapot'

port = 4567
server = Teapot.new(port)

server.get('/') do |_req, res|
  res.body = File.read('views/index.html')
end

server.listen
