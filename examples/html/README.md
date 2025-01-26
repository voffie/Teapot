<p align="center">
  <h1 align="center"><b>HTML</b></h1>
</p>

This example shows you how to render a HTML file using the `res.body()` attribute.

# Usage

Teapot can render HTML by setting the response's `body` attribute to the file as shown below

```rb
require 'voffie_teapot'

port = 4567
server = VoffieTeapot.new(port)

server.get('/') do |req, res|
  res.body = File.read(HTML_FILE_LOCATION)
end

server.listen
```
