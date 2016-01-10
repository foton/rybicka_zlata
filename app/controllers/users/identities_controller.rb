class Users::IdentitiesController < ApplicationController
	def create
    build_identity
    authorize!(:create)

    if @identity.save
    	flash[:notice]=t("user.contacts.added", contact: @identity.to_s)
    	redirect_to my_page_url
    else	
    	flash[:error]=t("user.contacts.not_added", contact: @identity.to_s)
    	@new_contact=@identity
      @user=@identity.user
    	render template: "profiles/my"
    end	
	end
	
	def destroy
    find_identity
    authorize!(:destroy)

    if @identity.destroy
    	flash[:notice]=t("user.contacts.deleted", contact: @identity.to_s)
    	redirect_to my_page_url
    else	
    	flash[:error]=t("user.contacts.not_deleted", contact: @identity.to_s)
    	redirect_to my_page_url
    end
	end	

  private

  def build_identity
    @identity=User::Identity.new(identity_params)     
    @identity.user_id=params[:user_id]
  end	

  def find_identity
  	@identity=User::Identity.find(params[:id]) 
  end	

  def authorize!(action)
  	 #user can manage only it's own identities
     raise User::NotAuthorized if current_user.id != @identity.user_id
     case action
       when :create 
	       unless @identity.local?
	        raise User::NotAuthorized #no one can make other Identities than "local" through this controller
	       end	
     end  
  end	
	
	def identity_params
		params.require(:user_identity).permit(:email, :provider)
	end
end