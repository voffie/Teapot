require 'teapot'

port = 4567
server = Teapot.new(port)
path = '/params/:is/:awesome'

server.get(path) do |req, res|
  template = File.read('views/index.html')

  # Populates the example page with data
  template.gsub!('<%= dynamic_route %>', path)
  template.gsub!('<%= path %>', req[:resource])
  template.gsub!('<%= params %>', req[:params].to_s)

  res.body = template
end

server.listen
