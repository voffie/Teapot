require 'voffie_teapot'

port = 4567
server = VoffieTeapot.new(port)
path = '/params/:example'

server.get(path) do |req, res|
  template = File.read('views/index.html')

  # Populates the example page with data
  template.gsub!('<%= dynamic_route %>', path)
  template.gsub!('<%= path %>', req[:resource])
  # Access the params through the req[:params] object
  template.gsub!('<%= params %>', req[:params].to_s)

  res.body = template
end

server.listen
