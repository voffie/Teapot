require 'teapot'

port = 4567
server = Teapot.new(port)

server.get('/') do |_req, res|
  # Loads the slim file called 'index.slim'
  res.body = res.slim(:index)
end

server.listen
