<p align="center">
  <h1 align="center"><b>Middleware</b></h1>
</p>

This example shows you how to create middlewares using the `use(path, lambda)` method. 

# Usage

Teapot can run middleware both globally and on a route specific level as seen below:

```rb
require 'voffie_teapot'

port = 4567
server = VoffieTeapot.new(port)

# Global middleware
server.use('*') do |req, res|
  p "Global middleware"
end

# Route specific middleware
server.use('/') do |req, res|
  p "Route specific middleware"
end

server.get('/') do |req, res|
  res.body = File.read(HTML_FILE_LOCATION)
end

server.listen
```
