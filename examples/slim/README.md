<p align="center">
  <h1 align="center"><b>Slim</b></h1>
</p>

This example shows you how to render a Slim file using the `res.body()` attribute.

# Usage

Teapot can render Slim by setting the response's `body` attribute to the file as shown below. By default Teapot expects a `views/layout.slim` file to exist.

The `slim` function takes in three arguments:
<br>
**File_name** (symbol): the name of the slim file to render
<br>
**Layout** (boolean, default: true): boolean value representing using a layout or not
<br>
**Locals** (hash): hash containing variables to possibly render

```rb
require 'teapot'

port = 4567
server = Teapot.new(port)

server.get('/') do |req, res|
  res.body = res.slim(:NAME_OF_SLIM_FILE)
end

server.listen(port, lambda { puts "Example app listening on port #{port}" })
```

### Without layout

To render without a layout you can simply pass `false` as the second argument

```rb
require 'teapot'

port = 4567
server = Teapot.new(port)

server.get('/') do |req, res|
  res.body = res.slim(:NAME_OF_SLIM_FILE, false)
end

server.listen(port, lambda { puts "Example app listening on port #{port}" })
```

### With variables

To render Ruby variables in your Slim templates pass a hash as the third argument

```rb
require 'teapot'

port = 4567
server = Teapot.new(port)

server.get('/') do |req, res|
  res.body = res.slim(:index, true, {toggle: true, VARIABLE_NAME: "VALUE"})
end

server.listen(port, lambda { puts "Example app listening on port #{port}" })

```

```
div
  -if toggle
    p Value of VARIABLE_NAME #{VARIABLE_NAME}
```
