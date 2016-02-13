class ConnectionsController < ApplicationController
	def index 
	  load_connections
    build_connection
	end  

	def show
	  load_connection
	end 

	# def new
	#   build_connection
	# end 

  def create
    build_connection
    save_connection(t("connection.views.added", fullname: @connection.fullname), t("connection.views.not_added", fullname: @connection.fullname)) or render 'index'
	end

	def edit
	 load_connection
	 build_connection
	end  

	def update
	 load_connection
	 build_connection
	 save_connection(t("connection.views.updated", fullname: @connection.fullname), t("connection.views.not_updated", fullname: @connection.fullname)) or render 'edit'
	end    

	def destroy
    load_connection
    destroy_connection
    redirect_to user_connections_url(@user)
	end	

  private

    def load_connections
      @connections||=connection_scope
    end  

    def load_connection
      @connection||=connection_scope.find(params[:id]) 
    end 

    def build_connection
      @connection||=connection_scope.build
      @connection.attributes=connection_params     
      @connection.owner=@user #params[:user_id]
    end	

    def save_connection(msg_ok,msg_bad)
      if @connection.save
        flash[:notice]=msg_ok
        redirect_to user_connections_url(@user)
        true
      else  
        flash[:error]=msg_bad
        @new_contact=@connection
        @user=@connection.owner
        false
      end 
    end

    def destroy_connection
      if @connection.destroy
        flash[:notice]=t("connection.views.deleted", fullname: @connection.fullname)
      else  
        flash[:error]=t("connection.views.not_deleted", fullname: @connection.fullname)
      end
    end  

    def connection_params
      connection_params = params[:connection]
      connection_params ? connection_params.permit(:email, :name) : {}
    end

    def connection_scope
      @user=current_user
      #here I can solve authorization to access objects
      #user can manage only it's own connections
      Connection.where(owner_id: @user.id).friends
    end  

end