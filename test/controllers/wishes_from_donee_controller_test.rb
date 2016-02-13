require 'test_helper'

class Wishes::FromDoneeControllerTest < ActionController::TestCase
	include Devise::TestHelpers

	def setup
	  @request.env["devise.mapping"] = Devise.mappings[:admin]
	  @current_user=User.create!(name: "Pepík", email: "pepik@josef.cz",password:"nezalezi")
	  @current_user.confirm
	  sign_in @current_user

    @donor_mama=create_donor_for(@current_user, "Máma")
    @donor_tata=create_donor_for(@current_user, "Táta")
	  @cu_as_donee_wishes=[]

	end

  


  def test_index_show_my_wishes
    Wish::FromDonee.create!(author: @current_user, title: "My first wish", description: "This is my first wish I am trying", donor_conn_ids: [@donor_mama.id, @donor_tata.id] )
    Wish::FromDonee.create!(author: @current_user, title: "Big gun", description: "You now, for boom and bang", donor_conn_ids: [@donor_tata.id] )

  	get :index, {user_id: @current_user.id}

    assert assigns(:wishes).present?
  	assert_equal @current_user.my_wishes, assigns(:wishes)
    assert_template "index"
    
    assert assigns(:wish).present?
    assert_not_nil assigns(:user)
    assert assigns(:wish).kind_of?(Wish::FromDonee)
  end	

  private

    def create_donor_for(user, con_name)
    	create_donor_from_hash({user: user, connection: {name: con_name}})	
    end	

    def create_donor_from_hash(h)	
    	user=h[:user]
    	conn_name=h[:connection][:name]
    	conn_email=h[:connection][:email]

	    conns= user.connections.find_by_name(conn_name)
	    if conn_email.present? && conns.present?
	      conns=conns.select {|conn| con.email == conn_email}
	    else
	       conn_email="#{conn_name}@example.com"
	    end  
	  
		  if conns.blank?
		     #lets create it 
		     conn=Connection.new(name: conn_name, email: conn_email)
		     user.connections << conn
		     user.connections.reload
		  elsif conns.size != 1
		    raise "Ambiguous match for '#{h[:connection]}' for user '#{user.username}': #{conns.join("\n")}"
		  else
		    conn=conns.first  
		  end  
		  conn
    end	

end
