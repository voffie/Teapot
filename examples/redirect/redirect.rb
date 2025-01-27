require 'voffie_teapot'

port = 4567
server = VoffieTeapot.new(port)

server.get('/') do |_req, res|
  # Redirects the user to '/redirect'
  res.redirect('/redirect')
end

# Route to capture the redirect
server.get('/redirect') do |_req, res|
  res.body = File.read('views/index.html')
end

server.listen
