# frozen_string_literal: true

require "minitest/test_task"

task default: :test

Minitest::TestTask.create(:test) do |t|
  t.warning = true
  t.test_globs = %w[temp].map { |n| "test/#{n}_test.rb" }
end
