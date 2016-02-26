require 'test_helper'

class Wishes::FromDoneeControllerTest < ActionController::TestCase
	include Devise::TestHelpers

	def setup
	  @request.env["devise.mapping"] = Devise.mappings[:admin]
	  @current_user=User.create!(name: "Pepík", email: "pepik@josef.cz",password:"nezalezi")
	  @current_user.confirm
	  sign_in @current_user

    @conn_mama=create_connection_for(@current_user, {name: "Máma"})
    @conn_tata=create_connection_for(@current_user, {name: "Táta"})

    @other_user=create_test_user!(name: "OtherGuy")
    @conn_to_current_user=create_connection_for(@other_user, {name: "Pepa", email: @current_user.email})
    @conn_tata_from_other_user=create_connection_for(@other_user, {name: "Táta"})
    #@conn_to_other_user=create_connection_for(@current_user, {name: "other user", email: @other_user.email})
	end

  def test_index_of_my_wishes
    create_author_wish
    create_shared_wish

  	get :index, {user_id: @current_user.id}

    assert assigns(:wishes).present?
  	assert_equal @current_user.donee_wishes, assigns(:wishes)
    assert_template "index"
    assert_not_nil assigns(:user)
  end	

  def test_index_no_wish_yet
  	#Wish.destroy_all
    assert @current_user.donee_wishes.blank?

  	get :index, {user_id: @current_user.id}
   
    assert_equal [], assigns(:wishes)
    assert_template "index"
    assert_not_nil assigns(:user)
  end	
  
  def test_show_of_my_own_wish
    author_wish=create_author_wish

  	get :show, {user_id: @current_user.id, id: author_wish.id}
    
    assert assigns(:wish).present?
    assert_not_nil assigns(:user)
    assert assigns(:wish).kind_of?(Wish::FromDonee)
    assert_equal author_wish, assigns(:wish)
  end	

  def test_show_of_shared_wish
    shared_wish=create_shared_wish

    get :show, {user_id: @current_user.id, id: shared_wish.id}
    
    assert assigns(:wish).present?
    assert_not_nil assigns(:user)
    assert assigns(:wish).kind_of?(Wish::FromDonee)
    assert_equal shared_wish, assigns(:wish)
  end 

  def test_edit_shared_wish
    shared_wish=create_shared_wish
    usr_conns=@current_user.connections-[@current_user.base_connection]
    available_donor_conns=usr_conns

    get :edit, {user_id: @current_user.id, id: shared_wish.id}
    
    assert_not_nil assigns(:wish)  
    assert_equal shared_wish, assigns(:wish)  
    
    assert_not_nil assigns(:user_connections)
    assert_equal usr_conns , assigns(:user_connections)    
    
    assert_not_nil assigns(:user_groups)
    assert_equal @current_user.groups , assigns(:user_groups)    

    assert_not_nil assigns(:available_donor_connections)
    assert_equal available_donor_conns , assigns(:available_donor_connections)    

  end

  def test_add_donors_to_shared_wish
    shared_wish=create_shared_wish
    conn_segra=create_connection_for(@current_user, {name: "Ségra"})
    #donee can change only donors from his connections

    new_title="Much better title"
    new_description= "something for me and my dad"

    original_title= shared_wish.title
    original_description= shared_wish.description
    original_donor_conn_ids=shared_wish.donor_connections.collect {|c| c.id}
    assert_equal [@conn_tata_from_other_user.id], original_donor_conn_ids
    original_donee_conn_ids=shared_wish.donee_connections.collect {|c| c.id}

    edit_wish_hash={title: new_title, description: new_description, donee_conn_ids: [@conn_tata.id]  }
    edit_wish_hash[:donor_conn_ids]=[@conn_mama.id, conn_segra.id]

    patch :update, {user_id: @current_user.id, id: shared_wish.id, wish: edit_wish_hash }
    
    assert_response :redirect
    assert_redirected_to user_my_wish_path(@current_user, shared_wish)
    assert_equal "Seznam potenciálních dárců pro '#{original_title}' byl úspěšně aktualizován.", flash[:notice]

    shared_wish.reload
    #wish atributes, forbidden to donee, are not changed
    assert_equal original_title, shared_wish.title
    assert_equal original_description, shared_wish.description
    assert_equal original_donee_conn_ids.sort, (shared_wish.donee_connections.collect {|c| c.id}).sort
    #but donor are added
    assert_equal (original_donor_conn_ids+edit_wish_hash[:donor_conn_ids]).sort, (shared_wish.donor_connections.collect {|c| c.id}).sort 
  end

  def test_manage_own_donors_of_shared_wish
    shared_wish=create_shared_wish
    conn_segra=create_connection_for(@current_user, {name: "Ségra"})
    #donee can change only donors from his connections
    
    #add first set of donors
    original_my_donor_conn_ids=[@conn_mama.id, @conn_tata.id]
    shared_wish.merge_donor_conn_ids(original_my_donor_conn_ids, @current_user)
    shared_wish.save!
    original_donor_conn_ids=shared_wish.donor_connections.collect {|c| c.id}
    assert_equal ([@conn_tata_from_other_user.id]+original_my_donor_conn_ids), original_donor_conn_ids

    #tata is out, mama left and segra is added
    edit_wish_hash={donor_conn_ids: [@conn_mama.id, conn_segra.id]}

    patch :update, {user_id: @current_user.id, id: shared_wish.id, wish: edit_wish_hash }
    
    assert_response :redirect
    assert_redirected_to user_my_wish_path(@current_user, shared_wish)
    assert_equal "Seznam potenciálních dárců pro '#{shared_wish.title}' byl úspěšně aktualizován.", flash[:notice]

    shared_wish.reload
    new_donor_conn_ids=[@conn_tata_from_other_user.id, @conn_mama.id, conn_segra.id]
    assert_equal (new_donor_conn_ids).sort, (shared_wish.donor_connections.collect {|c| c.id}).sort 
  end

  #DELETE should not delete wish, but only delete user as donee
  def test_destroy
    shared_wish=create_shared_wish

    delete :destroy, {user_id: @current_user.id, id: shared_wish.id}
    
    assert_response :redirect
    assert_redirected_to user_my_wishes_path(@current_user)
    assert_equal "Byli jste odebráni z obdarovaných u přání '#{shared_wish.title}'.", flash[:notice]
    
    refute Wish.where(id: shared_wish.id).blank?
    refute @current_user.donee_wishes.include?(shared_wish)
  end

  def test_cannot_update_wish_if_is_not_donee
    nonshared_wish=create_nonshared_wish

    patch :update, {user_id: @current_user.id, id: nonshared_wish.id}

    assert_response :not_found
  end  

  #user cannot see wish as donee if his/her is not between donees
  def test_cannot_see_donee_wish_if_is_not_donee
    nonshared_wish=create_nonshared_wish
    
    get :show, {user_id: @current_user.id, id: nonshared_wish.id}

    assert_response :not_found
  end  

  private

    def create_author_wish
      author_wish=Wish::FromAuthor.new(author: @current_user, title: "My first wish", description: "This is my first wish I am trying")
      author_wish.merge_donor_conn_ids([@conn_mama.id,@conn_tata.id], @current_user )
      author_wish.save!
      author_wish=Wish::FromDonee.find(author_wish.id)
    end
      
    def create_shared_wish
      shared_wish=Wish::FromAuthor.new(author: @other_user, donee_conn_ids: [@conn_to_current_user.id], title: "My shared wish", description: "I am sharing this wish with Pepa (aka current_user)" )    
      shared_wish.merge_donor_conn_ids([@conn_tata_from_other_user.id], @other_user )
      shared_wish.save!
      shared_wish=Wish::FromDonee.find(shared_wish.id)
    end  

    def create_nonshared_wish
      nonshared_wish=Wish::FromAuthor.new(author: @other_user, title: "Only my wish", description: "I am the only donee, but Pepa is between donors") 
      nonshared_wish.merge_donor_conn_ids([@conn_to_current_user.id], @other_user )    
      nonshared_wish.save!
      nonshared_wish
    end

end
