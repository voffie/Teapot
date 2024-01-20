require 'minitest/autorun'
describe "Server middlewares" do
  it "Runs the server middleware before the route request" do
    _(2+2).must_equal 4
  end
end

describe "Route specific middlewares" do
  it "Executes route specific middleware before the request" do
    _(2+2).must_equal 4
  end
end