<p align="center">
  <h1 align="center"><b>Cookies</b></h1>
</p>

This example shows you how to add cookies to your page using the `res.create_cookie()` function.

# Usage

The `create_cookie()` function takes two params:
<br>
**Name** (string): name of the cookie
<br>
**Value** (string): the value of the cookie

```rb
require 'teapot'

port = 4567
server = Teapot.new(port)

server.get('/') do |req, res|
  res.create_cookie(NAME, VALUE)
end

server.listen(port, lambda { puts "Example app listening on port #{port}" })

```
