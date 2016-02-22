class GroupsController < ApplicationController
	def index 
	  load_groups
    build_group
	end  

	def show
	  load_group
	end 

	# def new
	#   build_group
	# end 

  def create
    build_group
    create_group(t("group.views.added", name: @group.name), t("group.views.not_added", name: @group.name)) or render 'index'
	end

	def edit
	 load_group
   load_user_connections
	end  

	def update
	 load_group
   load_user_connections
   build_group #update group from params
	 save_group(t("group.views.updated", name: @group.name), t("group.views.not_updated", name: @group.name)) or render 'edit'
	end    

	def destroy
    load_group
    destroy_group
    redirect_to user_groups_url(@user)
	end	

  private

    def load_groups
      @groups||=group_scope
    end  

    def load_group
      @group||=group_scope.find(params[:id]) 
    end 

    def build_group
      @group||=group_scope.build
      @group.attributes=group_params     
      @group.user=@user #params[:user_id]
    end	

    def save_group(msg_ok,msg_bad)
      if @group.save
        flash[:notice]=msg_ok
        redirect_to user_group_url(@user,@group)
        true
      else  
        flash[:error]=msg_bad
        @new_contact=@group
        @user=@group.user
        false
      end 
    end

    def create_group(msg_ok,msg_bad)
      if @group.save
        flash[:notice]=msg_ok
        redirect_to edit_user_group_url(@user,@group) #to add connections
        true
      else  
        flash[:error]=msg_bad
        @new_contact=@group
        @user=@group.user
        false
      end 
    end

    def destroy_group
      if @group.destroy
        flash[:notice]=t("group.views.deleted", name: @group.name)
      else  
        flash[:error]=t("group.views.not_deleted", name: @group.name)
      end
    end  

    def group_params
      group_params = params[:group]
      #The permitted scalar types are String, Symbol, NilClass, Numeric, TrueClass, FalseClass, Date, Time, DateTime, StringIO, IO, ActionDispatch::Http::UploadedFile and Rack::Test::UploadedFile.
      #To declare that the value in params must be an array of permitted scalar values map the key to an empty array:
      group_params ? group_params.permit(:name, connection_ids: []) : {}
    end

    def group_scope
      @user=current_user
      #here I can solve authorization to access objects
      #user can manage only it's own groups
      Group.where(user_id: @user.id)
    end  

    def load_user_connections
      @user_connections=@user.friend_connections
    end  

end
