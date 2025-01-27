<p align="center">
  <h1 align="center"><b>Teapot 🫖</b></h1>
  <p align="center">
    A minimal web server
    <br />
    <br />
    <strong>Built with</strong>
    <br />
    <img alt="Ruby" width="30px" style="padding-right:10px;" src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/ruby/ruby-original.svg" />
    <br />
  </p>
</p>

[![Gem Version](https://badge.fury.io/rb/voffie_teapot.svg)](https://badge.fury.io/rb/voffie_teapot)
[![Testing](https://github.com/voffie/teapot/actions/workflows/test.yml/badge.svg)](https://github.com/voffie/teapot/actions/workflows/test.yml)

Teapot was named from the HTTP error code [**_"418 I'm a teapot"_**](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/418).

> NOTE: Teapot is not meant to be a replacement for more well known webservers! Teapot is lacking vital security features. The main goal for this project was for me to learn how web servers work!

## Table of Contents
- [Teapot](#teapot)
    - [Table of Contents](#table-of-contents)
    - [Getting started](#getting-started)
    - [Features](#features)
    - [Examples](#examples)
    - [Unsupported features](#unsupported-features)
    - [Contributing](#contributing)

# Getting started

```ruby
# app.rb
require 'voffie_teapot'

server = VoffieTeapot.new()
port = 4567

server.get('/') do |req, res|
  res.body = 'hello world'
end

server.listen(port)
```

Install the gems needed:

```shell
gem install voffie_teapot
```

And run with:

```shell
ruby app.rb
```

This will spin up a server which can be accessed through http://localhost:4567

# Features

To use [Slim](https://slim-template.github.io/) features make sure to have it installed:

```shell
gem install slim
```

Teapot supports different features such as:

- **Routing**: `GET` and `POST` routes with support for route parameters.
- **Middleware**: Make changes to the request or response before the route handler.
- **Slim Templating**: Render Slim templates with layout support.
- **Static Files**: Serve static files from the `./public` directory.

# Examples

The available examples are:
- [Cookies](./examples/cookies): Set and read cookies in your application.
- [HTML](./examples/html): Serve and render static HTML files.
- [Redirect](./examples/redirect): Redirect users to another path.
- [Route params](./examples/route-params): Handle dynamic routes and access route parameters.
- [Slim](./examples/slim): Use Slim template to render dynamic content.

All examples can be found [here](./examples)

# Unsupported Features

Since this project was meant as a learning experience, certain features are not available. Some of these are:
- **Multiple HTTP method support**: Currently only `GET` & `POST` are supported. Next methods to be supported would be `PUT` & `DELETE`.
- **Security**: Teapot does not have any rate limiting built in or other security meassures.

# Contributing

As mentioned at the top, this project was meant to be a learning experience for me. However I appreciate and welcome anyone that wants to submit changes!
