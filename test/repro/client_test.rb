require "test_helper"

class Repro::ClientTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Repro::Client::VERSION
  end
end
