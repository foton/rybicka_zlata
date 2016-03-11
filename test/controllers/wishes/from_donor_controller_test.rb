require 'test_helper'

class Wishes::FromDonorControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @bart=create_test_user!(name: "Bart")
    @bart.confirm

    @marge= create_test_user!(name: "Marge")
    @homer= create_test_user!(name: "Homer")
    @lisa= create_test_user!(name: "Lisa")
    #@maggie= create_test_user!(name: "Maggie")
    
    @conn_bart2marge=create_connection_for(@bart, {name: "Mom", email: @marge.email})
    @conn_bart2homer=create_connection_for(@bart, {name: "Dad", email: @homer.email})
    @conn_marge2bart=create_connection_for(@marge, {name: "Son", email: @bart.email})
    @conn_marge2lisa=create_connection_for(@marge, {name: "Sweet minime", email: @lisa.email})
    @conn_homer2bart=create_connection_for(@homer, {name: "Minime", email: @bart.email})
    @conn_homer2lisa=create_connection_for(@homer, {name: "MiniMarge", email: @lisa.email})

    @marge_wish=create_marge_wish
    sign_in @bart
  end

  def test_index_of_others_wishes

    hw=create_homer_wish

    get :index, {user_id: @bart.id}

    assert assigns(:wishes_by_donees).present?
    assert_equal [ [@homer,[hw]] , [@marge,[@marge_wish]] ], assigns(:wishes_by_donees).to_a
    assert_template "index"
    assert_not_nil assigns(:user)
  end 
 
  def test_cannot_see_others_wishes_for_other_user_account
    #signed_in as bart
    get :index, {user_id: @marge.id}
   
    assert_response :redirect
    assert_redirected_to user_others_wishes_url(@bart)
    assert_equal "Nakukování k sousedům není dovoleno!", flash[:error]
  end
    
  def test_index_no_wish_yet
    sign_in @marge
    
    assert @marge.donor_wishes.blank?

    get :index, {user_id: @marge.id}
   
    assert_equal [], assigns(:wishes_by_donees).to_a
    assert_template "index"
    assert_not_nil assigns(:user)
    assert_equal @marge, assigns(:user)
  end 
  
  def test_show_wish
   
    get :show, {user_id: @bart.id, id: @marge_wish.id}
    
    assert assigns(:wish).present?
    assert_not_nil assigns(:user)
    assert assigns(:wish).kind_of?(Wish::FromDonor)
    assert_equal @marge_wish, assigns(:wish)
  end 

  def test_update
    # update just call method wish.do_action! from 'state_action=do_action' if it is allowed to user
    
    #for example do_action=book
    patch :update, {user_id: @bart.id, id: @marge_wish.id, state_action: :book}
          
    assert assigns(:wish).present?
    assert_not_nil assigns(:user)
    assert assigns(:wish).kind_of?(Wish::FromDonor)
    assert_equal @marge_wish, assigns(:wish)
    assert_equal "Přání 'More tall hairs' bylo zarezervováno pro 'Bart'", flash[:notice]

    @marge_wish.reload
    assert @marge_wish.booked?
    assert @marge_wish.booked_by?(@bart)
  end  

  def test_do_not_update_if_action_is_not_allowed_to_user
    # update just call method wish.do_action! from 'state_action=do_action' if it is allowed to user
    
    #for example do_action=fulfilled is reserved for donees
    patch :update, {user_id: @bart.id, id: @marge_wish.id, state_action: :fulfilled}
          
    assert assigns(:wish).present?
    assert_not_nil assigns(:user)
    assert assigns(:wish).kind_of?(Wish::FromDonor)
    assert_equal @marge_wish, assigns(:wish)
    assert_equal nil, flash[:notice]

    @marge_wish.reload
    refute @marge_wish.fulfilled?
  end  

  private

    def create_marge_wish
      wish=Wish::FromAuthor.new(author: @marge, title: "More tall hairs", description: "And more bluish!")
      wish.merge_donor_conn_ids([@conn_marge2bart.id, @conn_marge2lisa.id], @marge )
      wish.save!
      Wish::FromDonor.find(wish.id)
    end
      
    def create_homer_wish
      wish=Wish::FromAuthor.new(author: @homer, title: "More Duff beer", description: "And hairs too!")
      wish.merge_donor_conn_ids([@conn_homer2bart.id, @conn_homer2lisa.id], @homer )
      wish.save!
      Wish::FromDonor.find(wish.id)
    end  

end
