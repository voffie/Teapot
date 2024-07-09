require 'minitest/autorun'
require_relative '../lib/teapot'

server = Teapot.new()
port = 4568

server_thread = Thread.new do
  server.listen(port, lambda { puts "Example app listening on port #{port}" })
end

client = TCPSocket.new "localhost", port

describe "Route errors" do
  it "Returns 404 if route is not found" do

    server.get('/temp') do |req, res|
      res.body = "Test body"
    end

    client.send "GET / HTTP/1.0\r\n\r\n", 0

    data = []

    while line = client.gets
      data.push(line)
    end

    client.close
    server_thread.kill
    assert_equal(data[0], "HTTP/1.1 404\r\n")
  end
end