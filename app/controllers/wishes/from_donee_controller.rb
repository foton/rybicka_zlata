class Wishes::FromDoneeController < ApplicationController

	def index 
	  load_wishes
	end  

	def show
	  load_wish
	end 

	def edit
	 load_wish
   load_user_connections
   load_user_groups
	 build_wish
	end  

	def update
   
	 load_wish
   load_user_connections
   load_user_groups
	 build_wish #update wish from params
	 save_wish(updated_message, not_updated_message) or render 'edit'
	end    

	def destroy
    load_wish
    destroy_wish
    redirect_to user_my_wishes_url(@user)
	end	

  private

    def load_wishes
      @wishes||=wish_scope
    end  

    def load_wish
      @wish||=wish_scope.find(params[:id]) 
    end 

    def build_wish
      @wish||=wish_scope.build
      donor_conn_ids=wish_params.delete(:donor_conn_ids)
      @wish.attributes=wish_params    
      @wish.merge_donor_conn_ids(donor_conn_ids, @user)
    end	

    def save_wish(msg_ok,msg_bad)
      if @wish.save
        flash[:notice]=msg_ok
        redirect_to user_my_wish_url(@user,@wish)
        true
      else  
        flash[:error]=msg_bad
        @user=@wish.author
        false
      end 
    end
   
    def destroy_wish
      if @wish.destroy(current_user)
        flash[:notice]=t("wish.from_donee.views.deleted", title: @wish.title)
      else  
        flash[:error]=t("wish.from_donee.views.not_deleted", title: @wish.title)
      end
    end  

    def wish_params
      unless defined?(@wish_params)
        @wish_params = params[:wish_from_donee] || ActionController::Parameters.new({})
        @wish_params[:donor_conn_ids]=[] if @wish_params[:donor_conn_ids].blank?
        @wish_params[:donor_conn_ids]=@wish_params[:donor_conn_ids].collect {|c| c.to_i}
        
        #The permitted scalar types are String, Symbol, NilClass, Numeric, TrueClass, FalseClass, Date, Time, DateTime, StringIO, IO, ActionDispatch::Http::UploadedFile and Rack::Test::UploadedFile.
        #To declare that the value in params must be an array of permitted scalar values map the key to an empty array:
        @wish_params = @wish_params.permit(donor_conn_ids: []) unless @wish_params.blank?
      end
      @wish_params  
    end

    def wish_scope
      @user=current_user
      #here I can solve authorization to access objects
      #user can manage only it's own wishs
      @user.donee_wishes
    end  

    def load_user_connections
      @user_connections=@user.friend_connections
      @available_donor_connections=@wish.available_donor_connections_from(@user_connections)
    end  

    def load_user_groups
      @user_groups=@user.groups.includes(:connections)
    end 

    def updated_message
      t("wish.from_donee.views.updated", title: @wish.title) 
    end  

    def not_updated_message
      t("wish.from_donee.views.not_updated", title: @wish.title) 
    end  
end
