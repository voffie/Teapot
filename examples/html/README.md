<p align="center">
  <h1 align="center"><b>HTML</b></h1>
</p>

This example shows you how to render a HTML file using the `res.body()` attribute.

# Usage

Teapot can render HTML by setting the response's `body` attribute to the file as shown below

```rb
require 'teapot'

server = Teapot.new()
port = 4567

server.get('/') do |req, res|
  res.body = File.read(HTML_FILE_LOCATION)
end

server.listen(port, lambda { puts "Example app listening on port #{port}" })


```
