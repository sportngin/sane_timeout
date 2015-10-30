require 'bundler/setup'
require 'minitest/unit'
require 'minitest/autorun'
require 'sane_timeout'

module Minitest
  module Assertions
    def assert_nothing_raised(*)
      yield
    end
  end
end
