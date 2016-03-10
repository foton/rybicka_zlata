class Users::IdentitiesController < ApplicationController

  before_filter :set_user

# def index 
#    load_indentities
#  end  

# def show
#    load_identity
# end 

# def new
#    build_identity
# end 

  def create
    build_identity
    save_identity or render template: "profiles/my"
	end

  # def edit
  #   load_identity
  #   build_identity
  # end  

  # def update
  #   load_identity
  #   build_identity
  #   save_identity or render 'edit'
  # end    
	
	def destroy
    load_identity
    destroy_identity
    redirect_to my_profile_url
	end	

  private

    def load_identities
      @identities||=identity_scope
    end  

    def load_identity
      @identity||=identity_scope.find(params[:id]) 
    end 

    def build_identity
      @identity||=identity_scope.build
      @identity.attributes=identity_params     
      @identity.user_id=current_user.id #params[:user_id]
    end	

    def save_identity
      if @identity.save
        flash[:notice]=t("user.contacts.added", contact: @identity.to_s)
        redirect_to my_profile_url
        true
      else  
        flash[:error]=t("user.contacts.not_added", contact: @identity.to_s)
        @new_contact=@identity
        @user=@identity.user
        false
      end 
    end

    def destroy_identity
      if @identity.destroy
        flash[:notice]=t("user.contacts.deleted", contact: @identity.to_s)
      else  
        flash[:error]=t("user.contacts.not_deleted", contact: @identity.to_s)
      end
    end  

    def identity_params
      #here I can solve authorization of user for change of each attribute
      #
      # ---authorization model --- should not be here in controller
      # def assignable_post_fields 
      #   case role
      #     when :admin then %w[subject body state]
      #     when :author then %w[subject body]
      #   end
      # end
      # ---- end of authorization model ---
      #
      #  post_params=params[:post].slice(*Auth.current.assignable_post_fields)
      identity_params = params[:user_identity_as_contact]
      identity_params[:provider]=User::Identity::LOCAL_PROVIDER if identity_params
      identity_params ? identity_params.permit(:email, :provider) : {}
    end

    def identity_scope
      #here I can solve authorization to access objects
      #user can manage only it's own identities
      User::Identity::AsContact.where(user_id: @user.id)
    end  
 
    def not_peeking_url
      my_profile_url
    end  
end
