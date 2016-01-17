require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase
	def setup
		@owner=create_test_user!
		@user_to=create_test_user!(name: "Ford", email: "hitchhiker@galaxy.museum")
		@friendship=Friendship.new(name: "Simon", email: "simon@says.com", owner_id: @owner.id)
		assert @friendship.valid?
	end	

	def test_cannot_be_without_email
		refute Friendship.new().valid?
		@friendship.email=nil
		refute @friendship.valid?
		assert_equal ["je povinná položka", "není platná hodnota"],@friendship.errors[:email]

		@friendship.email=""
		refute @friendship.valid?
    assert_equal ["je povinná položka", "není platná hodnota"],@friendship.errors[:email]  

		@friendship.email="not_valid@email_adress"
		refute @friendship.valid?
		assert_equal ["není platná hodnota"],@friendship.errors[:email]
	end	

	def test_cannot_be_without_owner
  	@friendship.owner_id=nil
		refute @friendship.valid?
		assert_equal ["je povinná položka"], @friendship.errors[:owner]

  	@friendship.owner_id=(User.last.id+1)
		refute @friendship.valid?
    assert_equal ["je povinná položka"], @friendship.errors[:owner]
	end	

	def test_cannot_be_without_name
		@friendship.name=nil
		refute @friendship.valid?
		assert_equal ["je povinná položka", "není platná hodnota"], @friendship.errors[:name]

  	@friendship.name=""
		refute @friendship.valid?
		assert_equal ["je povinná položka", "není platná hodnota"], @friendship.errors[:name]

		@friendship.name="ak"
		refute @friendship.valid?
		assert_equal ["není platná hodnota"], @friendship.errors[:name]
		
		@friendship.name="ako" #three chars is enough
		assert @friendship.valid?
    
    @friendship.name=" ak"
		refute @friendship.valid?
		assert_equal ["není platná hodnota"], @friendship.errors[:name]

		@friendship.name="ak "
		refute @friendship.valid?
		assert_equal ["není platná hodnota"], @friendship.errors[:name]

 	  @friendship.name="a k" #three chars is enough, space between is OK
		assert @friendship.valid?
	end	

  def test_can_be_without_to_user
  	@friendship.friend_id=nil
		assert @friendship.valid?
	end		

	def test_should_assign_existing_user_according_to_user_email
		#user.email should be also in identities! (user after_save callback)
		@friendship=Friendship.new(name: "Traveling Ford", email: @user_to.email, owner_id: @owner.id)
		assert @friendship.valid?
		assert_equal @user_to.id, @friendship.friend_id
	end	

	def test_should_assign_existing_user_according_to_email_from_identities
		#user's emails are searched in identities
		email="please@stop.me"
		@user_to.identities << User::Identity.local.create(email: email)

		@friendship=Friendship.new(name: "Traveling Ford", email: email, owner_id: @owner.id)
		assert @friendship.valid?
		assert_equal @user_to.id, @friendship.friend_id
	end	

  def test_show_existing_reg_user_in_full_name
  	@friendship.friend_id=@user_to.id
		assert "Simon [Ford]", @friendship.fullname  # friendsip.name + [friend.name] if friend is assigned
  end	

  def test_show_not_yet_assigned_reg_user_in_full_name
  	@friendship.friend_id=nil
  	assert "Simon [???]", @friendship.fullname
  end	

  def test_show_assigned_but_deleted_reg_user_in_full_name
  	@friendship.friend_id=@user_to.id
  	@user_to.destroy
  	assert "Simon [zrušen]", @friendship.fullname
  end	

end