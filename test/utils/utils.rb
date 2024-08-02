require 'minitest/autorun'
require_relative '../../lib/teapot/utils'

include Utils

describe "Regex parsing" do
  it "Works with /" do
    regex = generate_reg_exp("/")
    assert_equal(regex.match("/").to_s, "/")
  end

  it "Works with multiple parts" do
    regex = generate_reg_exp("/regex/test")
    assert_equal(regex.match("/regex/test").to_s, "/regex/test")
  end

  it "Works with dynamic route" do
    regex = generate_reg_exp("/params/:id")
    assert_equal(regex.match("/params/52").to_s, "/params/52")
  end
end

describe "URL params parsing" do
  it "Returns correct params" do
    assert_equal(get_params_from_path("/:param"), {":param"=>""})
  end

  it "Empty params" do
    assert_equal(get_params_from_path("/test/without/params"), {})
  end
end