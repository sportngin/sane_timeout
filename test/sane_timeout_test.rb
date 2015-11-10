require_relative 'test_helper'

class TestSaneTimeout < MiniTest::Unit::TestCase

  ### Tests that come with standard lib
  def test_queue
    q = Queue.new
    assert_raises(Timeout::Error, "[ruby-dev:32935]") {
      SaneTimeout::timeout(0.5) { q.pop }
    }
  end

  def test_timeout
    @flag = true
    Thread.start {
      sleep 0.1
      @flag = false
    }
    assert_nothing_raised("[ruby-dev:38319]") do
      SaneTimeout.timeout(1) {
        nil while @flag
      }
    end
    assert !@flag, "[ruby-dev:38319]"
  end

  def test_cannot_convert_into_time_interval
    bug3168 = '[ruby-dev:41010]'
    def (n = Object.new).zero?; false; end
    assert_raises(TypeError, bug3168) { SaneTimeout::timeout(n) { sleep 0.1 } }
  end



  ### tests not included in standard lib, but which standard lib does pass

  def test_non_timing_out_code_is_successful
    assert_nothing_raised do
      SaneTimeout::timeout(2) {
        true
      }
    end
  end

  def test_code_that_takes_too_long_is_stopped_and_raises
    assert_raises(Timeout::Error) do
      SaneTimeout::timeout(0.1) {
        sleep 10
      }
    end
  end

  def test_returns_block_value_when_not_timing_out
    retval = SaneTimeout::timeout(1){ "foobar" }
    assert_equal "foobar", retval
  end

end
