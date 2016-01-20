require 'test_helper'

class ConnectionTest < ActiveSupport::TestCase
	def setup
		@owner=create_test_user!
		@user_to=create_test_user!(name: "Ford", email: "hitchhiker@galaxy.museum")
		@connection=Connection.new(name: "Simon", email: "simon@says.com", owner_id: @owner.id)
		assert @connection.valid?
	end	

	def test_cannot_be_without_email
		refute Connection.new().valid?
		@connection.email=nil
		refute @connection.valid?
		assert_equal ["je povinná položka", "není platná hodnota"],@connection.errors[:email]

		@connection.email=""
		refute @connection.valid?
    assert_equal ["je povinná položka", "není platná hodnota"],@connection.errors[:email]  

		@connection.email="not_valid@email_adress"
		refute @connection.valid?
		assert_equal ["není platná hodnota"],@connection.errors[:email]
	end	

	def test_cannot_be_without_owner
  	@connection.owner_id=nil
		refute @connection.valid?
		assert_equal ["je povinná položka"], @connection.errors[:owner]

  	@connection.owner_id=(User.last.id+1)
		refute @connection.valid?
    assert_equal ["je povinná položka"], @connection.errors[:owner]
	end	

	def test_cannot_be_without_name
		@connection.name=nil
		refute @connection.valid?
		assert_equal ["je povinná položka", "není platná hodnota"], @connection.errors[:name]

  	@connection.name=""
		refute @connection.valid?
		assert_equal ["je povinná položka", "není platná hodnota"], @connection.errors[:name]

		@connection.name="ak"
		refute @connection.valid?
		assert_equal ["není platná hodnota"], @connection.errors[:name]
		
		@connection.name="ako" #three chars is enough
		assert @connection.valid?
    
    @connection.name=" ak"
		refute @connection.valid?
		assert_equal ["není platná hodnota"], @connection.errors[:name]

		@connection.name="ak "
		refute @connection.valid?
		assert_equal ["není platná hodnota"], @connection.errors[:name]

 	  @connection.name="a k" #three chars is enough, space between is OK
		assert @connection.valid?
	end	

  def test_can_be_without_to_user
  	@connection.friend_id=nil
		assert @connection.valid?
	end		

	def test_should_assign_existing_user_according_to_user_email
		#user.email should be also in identities! (user after_save callback)
		@connection=Connection.new(name: "Traveling Ford", email: @user_to.email, owner_id: @owner.id)
		assert @connection.valid?
		assert_equal @user_to.id, @connection.friend_id
	end	

	def test_should_assign_existing_user_according_to_email_from_identities
		#user's emails are searched in identities
		email="please@stop.me"
		@user_to.identities << User::Identity.local.create(email: email)

		@connection=Connection.new(name: "Traveling Ford", email: email, owner_id: @owner.id)
		assert @connection.valid?
		assert_equal @user_to.id, @connection.friend_id
	end	

  def test_show_existing_reg_user_in_full_name
  	@connection.friend_id=@user_to.id
		assert "Simon [Ford]", @connection.fullname  # friendsip.name + [friend.name] if friend is assigned
  end	

  def test_show_not_yet_assigned_reg_user_in_full_name
  	@connection.friend_id=nil
  	assert "Simon [???]", @connection.fullname
  end	

  def test_show_assigned_but_deleted_reg_user_in_full_name
  	@connection.friend_id=@user_to.id
  	@user_to.destroy
  	assert "Simon [zrušen]", @connection.fullname
  end	

end