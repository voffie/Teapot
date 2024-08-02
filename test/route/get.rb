require 'minitest/autorun'
require_relative '../../lib/teapot'

port = 4567
server = Teapot.new(port)

server.get('/') do |req, res|
  res.body = 'Test body'
end

server.get('/error') do |req, res|
  temp = 2 + "error"
  res.body = temp
end

Thread.new do
  server.listen(lambda { puts "Example app listening on port #{port}" })
end


describe "GET routes" do
  it "Returns correct page for existing route" do
    client = TCPSocket.new("localhost", port)
    client.send "GET / HTTP/1.1\r\n\r\n", 0
    
    data = []
    
    while line = client.gets
      data.push(line)
    end
    
    assert_equal(data[-1], "Test body")
  end
  
  it "Returns 404 error for nonexistent routes" do
    client = TCPSocket.new("localhost", port)
    client.send "GET /404 HTTP/1.1\r\n\r\n", 0

    data = []

    while line = client.gets
      data.push(line)
    end
    
    assert_equal(data[0], "HTTP/1.1 404\r\n")
  end

  it "Returns 500 error on path error" do
    client = TCPSocket.new("localhost", port)
    client.send "GET /error HTTP/1.1\r\n\r\n", 0

    data = []

    while line = client.gets
      data.push(line)
    end
    
    assert_equal(data[0], "HTTP/1.1 500\r\n")
  end
end