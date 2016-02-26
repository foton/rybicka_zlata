require 'test_helper'

class Wishes::FromAuthorControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    @current_user=User.create!(name: "Pepík", email: "pepik@josef.cz",password:"nezalezi")
    @current_user.confirm
    sign_in @current_user

    @conn_mama=create_connection_for(@current_user, {name: "Máma"})
    @conn_tata=create_connection_for(@current_user, {name: "Táta"})
    @conn_segra=create_connection_for(@current_user, {name: "Ségra"})

    @wish=Wish::FromAuthor.new(author: @current_user, title: "My first wish", description: "This is my first wish I am trying")
    @wish.merge_donor_conn_ids([@conn_mama.id, @conn_tata.id], @current_user )
    @wish.donee_conn_ids=[@conn_segra.id]
    @wish.save!
  end

  def test_get_new_for_my_wish
    get :new, {user_id: @current_user.id}

    assert_response :ok
    assert assigns(:wish).present?
    assert_equal @current_user, assigns(:wish).author
    assert_template 'new'
  end 

  def test_create_my_wish

    donor_conns=[@conn_mama,@conn_tata]
    donee_conns=[@conn_segra]
    wish_h= { title: "A special wish", description: "Wish me luck for tomorow!", donee_conn_ids: donee_conns.collect {|c| c.id} , donor_conn_ids:  donor_conns.collect {|c| c.id} }
    
    post :create, {user_id: @current_user.id, wish: wish_h}
    
    #redirect to edit, where donee and donors are added

    
    assert assigns(:wish).present?
    new_wish=assigns(:wish)
    assert_equal wish_h[:title], new_wish.title
    assert_equal wish_h[:description], new_wish.description
    assert new_wish.persisted?
    assert_equal donor_conns.sort, new_wish.donor_connections.sort
    assert_equal (donee_conns+[@current_user.base_connection]).sort, new_wish.donee_connections.sort

    assert_response :redirect
    assert_redirected_to user_my_wish_path(@current_user,new_wish)
    assert_equal "Přání '#{wish_h[:title]}' bylo úspěšně přidáno.", flash[:notice]
  end 

  def test_edit_my_wish
    get :edit, {user_id: @current_user.id, id: @wish.id}
    
    assert_not_nil assigns(:wish)  
    assert_equal @wish, assigns(:wish)  
    
    assert_not_nil assigns(:user_connections)
    assert_equal (@current_user.connections-[@current_user.base_connection]) , assigns(:user_connections)    
    
    assert_not_nil assigns(:user_groups)
    assert_equal @current_user.groups , assigns(:user_groups)    
  end

  def test_update_my_wish
    assert_equal [@conn_segra,@current_user.base_connection].sort, @wish.donee_connections.to_a.sort
    assert_equal [@conn_mama, @conn_tata].sort, @wish.donor_connections.to_a.sort

    new_title="Much better title"
    new_description= "something for me and my dad"
    edit_wish_hash={title: new_title, description: new_description, donee_conn_ids: [@conn_tata.id] ,donor_conn_ids: [@conn_mama.id, @conn_segra.id] }

    patch :update, {user_id: @current_user.id, id: @wish.id, wish: edit_wish_hash }
    
    assert_response :redirect
    assert_redirected_to user_my_wish_path(@current_user, @wish)
    assert_equal "Přání '#{new_title}' bylo úspěšně aktualizováno.", flash[:notice]

    @wish.reload
    assert_equal new_title, @wish.title
    assert_equal new_description, @wish.description
    assert_equal [@conn_tata,@current_user.base_connection].sort, @wish.donee_connections.to_a.sort
    assert_equal [@conn_mama,@conn_segra].sort, @wish.donor_connections.to_a.sort
  end

  def test_destroy
    delete :destroy, {user_id: @current_user.id, id: @wish.id}
    
    assert_response :redirect
    assert_redirected_to user_my_wishes_path(@current_user)
    assert_equal "Přání '#{@wish.title}' bylo úspěšně smazáno.", flash[:notice]
    
    assert Wish.where(id: @wish.id).blank?
  end

  def test_author_can_manage_donees
    @wish.merge_donor_conn_ids([@conn_mama.id], @current_user )
    @wish.donee_conn_ids=[@conn_segra.id, @conn_tata.id]
    @wish.save!

    assert_equal [@conn_segra, @conn_tata, @current_user.base_connection].sort, @wish.donee_connections.to_a.sort
    assert_equal [@conn_mama], @wish.donor_connections.to_a
    
    edit_wish_hash={donee_conn_ids: [@conn_tata.id,@conn_mama.id], donor_conn_ids: [@conn_segra.id]} #segra out, mama in

    patch :update, {user_id: @current_user.id, id: @wish.id, wish: edit_wish_hash }
    
    assert_response :redirect
    assert_redirected_to user_my_wish_path(@current_user, @wish)
    assert_equal "Přání '#{@wish.title}' bylo úspěšně aktualizováno.", flash[:notice]
    @wish.reload
    assert_equal [@conn_mama,@conn_tata,@current_user.base_connection].sort, @wish.donee_connections.to_a.sort
    assert_equal [@conn_segra].sort, @wish.donor_connections.to_a.sort
  end  


end
