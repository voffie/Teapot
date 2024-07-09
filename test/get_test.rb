require 'minitest/autorun'
require_relative '../lib/teapot'

server = Teapot.new()
port = 4567

server_thread = Thread.new do
  server.listen(port, lambda { puts "Example app listening on port #{port}" })
end

client = TCPSocket.new "localhost", port

describe "GET routes" do
  it "Returns correct body for existing route" do

    server.get('/') do |req, res|
      res.body = "Test body"
    end

    client.send "GET / HTTP/1.0\r\n\r\n", 0

    data = []

    while line = client.gets
      data.push(line)
    end

    client.close
    server_thread.kill
    assert_equal(data[-1], "Test body")
  end
end