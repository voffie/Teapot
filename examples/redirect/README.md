<p align="center">
  <h1 align="center"><b>Redirect</b></h1>
</p>

This example shows you how to redirect a user using the `res.redirect()` function.

# Usage

The `redirect()` function takes one param:
<br>
**Location** (string): redirect target url

```rb
require 'voffie_teapot'

port = 4567
server = VoffieTeapot.new(port)

server.get('/') do |req, res|
  res.redirect('/redirect')
end

server.get('/redirect') do |req, res|
  res.body = "I got redirected here"
end

server.listen
```
