require 'teapot'

server = Teapot.new()
port = 4567

server.get('/') do |req, res|
  res.create_cookie('example', 'cookie')
  res.create_cookie('example2', 'cookie2')
  res.body = File.read('views/index.html')
end

server.get('/test/:id/:foo/:lmao') do |req, res|
  res.body = req[:params]
end

server.get('/redirect') do |req, res|
  res.redirect('/')
end

server.get('/slim') do |req, res|
  res.body = res.slim(:index)
end

server.listen(port, lambda { puts "Example app listening on port #{port}" })
