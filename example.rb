require 'teapot'

server = Teapot.new()
port = 4567

server.get('/') do |response|
  response.create_cookie('example', 'cookie')
  response.body = File.read('views/index.html')
end

server.get('/redirect') do |response|
  response.redirect('/')
end

server.get('/slim') do |response|
  response.body = response.slim(:index)
end

server.listen(port, lambda { puts "Example app listening on port #{port}" })
