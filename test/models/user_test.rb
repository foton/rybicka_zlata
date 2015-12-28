require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "#displayed_name show #name if present, #email otherwise" do
    email="my@rybickazlata.cz"
    name="Karel"
    u=User.new(email: email)
    assert_equal email, u.displayed_name
    u.name=name
    assert_equal name, u.displayed_name
  end
end
