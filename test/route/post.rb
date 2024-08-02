require 'minitest/autorun'
require_relative '../../lib/teapot'

port = 4567
server = Teapot.new(port)

server.post('/ping') do |req, res|
  res.body = {"ping" => "pong"}.to_json
end

server.post('/error') do |req, res|
  temp = 2 + "error"
  res.body = temp
end

Thread.new do
  server.listen(lambda { puts "Example app listening on port #{port}" })
end


describe "POST routes" do
  it "Correct body returned" do
    client = TCPSocket.new("localhost", port)
    client.send "POST /ping HTTP/1.1\r\nContent-Type: application/json\r\nContent-Length: 19\r\n\r\n{\n\t\"ping\": \"pong\"\n}", 0

    data = []

    while line = client.gets
      data.push(line)
    end
    
    assert_equal(data[-1], "{\"ping\":\"pong\"}")
  end

  it "Returns 404 error for nonexistent routes" do
    client = TCPSocket.new("localhost", port)
    client.send "POST /404 HTTP/1.1\r\n\r\n", 0

    data = []

    while line = client.gets
      data.push(line)
    end
    
    assert_equal(data[0], "HTTP/1.1 404\r\n")
  end

  it "Returns 500 error on path error" do
    client = TCPSocket.new("localhost", port)
    client.send "POST /error HTTP/1.1\r\n\r\n", 0

    data = []

    while line = client.gets
      data.push(line)
    end
    
    assert_equal(data[0], "HTTP/1.1 500\r\n")
  end
end