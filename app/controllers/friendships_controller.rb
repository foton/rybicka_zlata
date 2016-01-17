class FriendshipsController < ApplicationController
	def index 
	  load_friendships
	end  

	def show
	  load_friendship
	end 

	def new
	  build_friendship
	end 

  def create
    build_friendship
    save_friendship or render 'new'
	end

	def edit
	 load_friendship
	 build_friendship
	end  

	def update
	 load_friendship
	 build_friendship
	 save_friendship or render 'edit'
	end    

	def destroy
    load_friendship
    destroy_friendship
    redirect_to my_page_url
	end	

  private

    def load_friendships
      @friendships||=friendship_scope
    end  

    def load_friendship
      @friendship||=friendship_scope.find(params[:id]) 
    end 

    def build_friendship
      @friendship||=friendship_scope.build
      @friendship.attributes=friendship_params     
      @friendship.user_id=current_user.id #params[:user_id]
    end	

    def save_friendship
      if @friendship.save
        flash[:notice]=t("friendship.added", contact: @friendship.to_s)
        redirect_to my_page_url
        true
      else  
        flash[:error]=t("friendship.not_added", contact: @friendship.to_s)
        @new_contact=@friendship
        @user=@friendship.user
        false
      end 
    end

    def destroy_friendship
      if @friendship.destroy
        flash[:notice]=t("friendship.deleted", contact: @friendship.to_s)
      else  
        flash[:error]=t("friendship.not_deleted", contact: @friendship.to_s)
      end
    end  

    def friendship_params
      friendship_params = params[:friendship]
      friendship_params ? friendship_params.permit(:email, :name) : {}
    end

    def friendship_scope
      #here I can solve authorization to access objects
      #user can manage only it's own friendships
      Friendship.where(owner_id: current_user.id)
    end  

end