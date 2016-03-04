require 'test_helper'


class WishesHelperTest < ActionView::TestCase

  def setup
    setup_wish
  end  
  
  def test_path_to_wish_action_for_donor
    assert_equal "", path_to_wish_action_for_user(:index, @donor)
    assert_equal user_others_wish_path(@donor,@wish), path_to_wish_action_for_user(:show, @donor, @wish)
    assert_equal new_user_author_wish_path(@donor), path_to_wish_action_for_user(:new, @donor)
    assert_equal "", path_to_wish_action_for_user(:create, @donor)
    assert_equal edit_user_others_wish_path(@donor,@wish), path_to_wish_action_for_user(:edit, @donor, @wish)
    assert_equal user_others_wish_path(@donor,@wish), path_to_wish_action_for_user(:update, @donor, @wish)
    assert_equal user_others_wish_path(@donor,@wish), path_to_wish_action_for_user(:destroy, @donor, @wish)
    assert_equal user_others_wish_path(@donor,@wish), path_to_wish_action_for_user(:delete, @donor, @wish)

    assert_equal user_others_wish_path(@donor,@wish), path_to_wish_action_for_user(:book, @donor, @wish)
    assert_equal user_others_wish_path(@donor,@wish), path_to_wish_action_for_user(:unbook, @donor, @wish)
    assert_equal user_others_wish_path(@donor,@wish), path_to_wish_action_for_user(:gifted, @donor, @wish)
    assert_equal user_others_wish_path(@donor,@wish), path_to_wish_action_for_user(:call_fo_co_donors, @donor, @wish)
    assert_equal user_others_wish_path(@donor,@wish), path_to_wish_action_for_user(:withdraw_call, @donor, @wish)

    #assert_raises(RuntimeError) { path_to_wish_action_for_user(:index, wish) }
  end
  
  def test_path_to_wish_action_for_donee
    assert_equal "", path_to_wish_action_for_user(:index, @donee)
    assert_equal user_my_wish_path(@donee,@wish), path_to_wish_action_for_user(:show, @donee, @wish)
    assert_equal new_user_author_wish_path(@donee), path_to_wish_action_for_user(:new, @donee)
    assert_equal "", path_to_wish_action_for_user(:create, @donee)
    assert_equal edit_user_my_wish_path(@donee,@wish), path_to_wish_action_for_user(:edit, @donee, @wish)
    assert_equal user_my_wish_path(@donee,@wish), path_to_wish_action_for_user(:update, @donee, @wish)
    assert_equal user_my_wish_path(@donee,@wish), path_to_wish_action_for_user(:destroy, @donee, @wish)
    assert_equal user_my_wish_path(@donee,@wish), path_to_wish_action_for_user(:delete, @donee, @wish)

    assert_equal user_my_wish_path(@donee,@wish), path_to_wish_action_for_user(:fullfilled, @donee, @wish)
  end
  
  def test_path_to_wish_action_for_author
    assert_equal "", path_to_wish_action_for_user(:index, @author)
    assert_equal user_author_wish_path(@author,@wish), path_to_wish_action_for_user(:show, @author, @wish)
    assert_equal new_user_author_wish_path(@author), path_to_wish_action_for_user(:new, @author)
    assert_equal "", path_to_wish_action_for_user(:create, @author)
    assert_equal edit_user_author_wish_path(@author,@wish), path_to_wish_action_for_user(:edit, @author, @wish)
    assert_equal user_author_wish_path(@author,@wish), path_to_wish_action_for_user(:update, @author, @wish)
    assert_equal user_author_wish_path(@author,@wish), path_to_wish_action_for_user(:destroy, @author, @wish)
    assert_equal user_author_wish_path(@author,@wish), path_to_wish_action_for_user(:delete, @author, @wish)

    assert_equal user_author_wish_path(@author,@wish), path_to_wish_action_for_user(:fullfilled, @author, @wish)
  end  

end  
