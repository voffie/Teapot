# frozen_string_literal: true

require 'minitest/test_task'

task default: :test

Minitest::TestTask.create(:test) do |t|
  t.warning = true
  t.test_globs = Dir['test/**/*'].select { |file| file.end_with? '.rb' }
end
