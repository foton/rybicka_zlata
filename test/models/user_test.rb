require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    #OmniAuth.config.full_host = Rails.env.production? ? 'https://domain.com' : 'http://localhost:3000'
    #OmniAuth.config.full_host = 'http://localhost:3000'
    OmniAuth.config.test_mode = true
    
    @user_name="John Doe"
    @user_email="john.doe@nowhere.com"
  end

  test "#displayed_name show #name if present, #email otherwise" do
    email="my@rybickazlata.cz"
    name="Karel"
    u=User.new(email: email)
    assert_equal email, u.displayed_name
    u.name=name
    assert_equal name, u.displayed_name
  end

  def test_delete_identities_on_destroy
    u=create_test_user!(email: "testme@dot.com")
    i0=u.identities.first  #created on creation of user
    i1=User::Identity.create(uid: "123456", provider: "test")
    i2=User::Identity.create(uid: "123456", provider: User::Identity::LOCAL_PROVIDER, email: "my@email.cz")
    i1.user=u
    i1.save!
    i2.user=u
    i2.save!
    u=User.find(u.id)

    assert_equal [i0.id, i1.id, i2.id].sort, ((u.identities.map {|i| i.id}).sort)
    u.destroy
    assert User::Identity.where(id: [i0.id, i1.id, i2.id]).blank?, "defined identities not destroyed: #{User::Identity.where(id: [i0.id, i1.id, i2.id]).to_yaml}"
    assert User::Identity.where(user_id: u.id).blank?, "User's identities not destroyed: #{User::Identity.where(user_id: u.id).to_yaml}"
  end  

  def test_got_admin
    assert User.new(email: "porybny@rybickazlata.cz").admin?
    refute User.new(email: "orybny@rybickazlata.cz").admin?
  end  

  def test_create_local_identity_on_local_registration
    email="jonh.doe@example.com"

    assert User::Identity.local.where(email: email).blank?

    user=User.new({name: "John Doe", email: email, password: "my_Password10"})
    #user.skip_confirmation!
    user.save!

    assert user.identities.local.where(email: email).present?
  end  

  def test_know_his_friendships
    u=create_test_user!
    p1= Friendship.new(email: "first@friendship.cz", name: "First")
    p2= Friendship.new(email: "second@friendship.cz", name: "second friendship")
    #inserting in reverse order!
    u.friendships << p2
    u.friendships << p1
    u.reload

    assert_equal [p1,p2], u.friendships.to_a  #friendships are ordered by name
  end  
end
