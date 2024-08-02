require 'minitest/autorun'
require_relative '../../lib/teapot/parser'

include Parser


describe "GET routes" do
  it "Returns correct page for existing route" do
    request = "GET / HTTP/1.1\r\nHost: localhost:4567\r\n"
    parsed_request = parse(request)
    assert_equal(parsed_request, {:method=>"GET", :resource=>"/", :http=>"HTTP/1.1", :Host=>"localhost:4567\r"})
  end
end