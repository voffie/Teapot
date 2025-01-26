<p align="center">
  <h1 align="center"><b>Route Params</b></h1>
</p>

This example shows you how to use and retrieve route params using the `req[:params]` property.

# Usage

The `req[:params]` property stores all params in a hash which allows the user to access each param by using `[":PARAM_NAME"]`

```rb
require 'voffie_teapot'

port = 4567
server = VoffieTeapot.new(port)

server.get('/params/:example') do |req, res|
  p req[:params][":example"]
  res.body = req[:params]
end

server.listen
```
