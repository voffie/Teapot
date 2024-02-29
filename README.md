<p align="center">
  <h1 align="center"><b>Teapot</b></h1>
  <p align="center">
    A minimal webserver
    <br />
    <br />
    <strong>Built with</strong>
    <br />
    <img alt="Ruby" width="30px" style="padding-right:10px;" src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/ruby/ruby-original.svg" />
    <br />
  </p>
</p>

Teapot was named from the HTTP error code [**_"418 I'm a teapot"_**](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/418).

> NOTE: Teapot is not meant to be a replacement for more well known webservers! Teapot is lacking vital security features. The main goal for this project was for me to learn how webservers are run!

# Getting started

Install the gem:

```shell
gem install teapot
```

Create index file:

```ruby
# app.rb
require 'teapot'

server = Teapot.new()
port = 4567

server.get('/') do |req, res|
  res.body = 'hello world'
end

server.listen(port, lambda { puts "Example app listening on port #{port}" })
```

Later run it with:

```shell
ruby app.rb
```

# Examples

Examples with descriptions can be found in the `examples` directory
