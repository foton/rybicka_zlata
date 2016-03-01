class Wishes::FromDonorController < ApplicationController

  def index 
    load_wishes.not_fullfilled
  end  

  def show
    load_wish
  end 

  def update
   load_wish
   updated_message=build_wish #update wish from params
   save_wish(updated_message, not_updated_message) or render 'edit'
  end    

  private

    def load_wishes
      @wishes||=wish_scope
    end  

    def load_wish
      @wish||=wish_scope.find(params[:id]) 
    end 

    def build_wish
      msg=@wish.send("#{wish_params[:state_action]}!", current_user) if wish_params[:state_action].present?
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
  
    def wish_params
      @wish_params ||= (params.permit(:state_action) || ActionController::Parameters.new({}) )
    end

    def wish_scope
      @user=current_user
      @user.donor_wishes
    end  

    def not_updated_message
      t("wish.from_donor.views.not_updated", title: @wish.title) 
    end  
end
