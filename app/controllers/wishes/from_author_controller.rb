class Wishes::FromAuthorController < ApplicationController
  
  def new
    build_wish
    load_user_connections
    load_user_groups
    @wish.author=@user
  end  
  
  def create
    build_wish
    load_user_connections
    load_user_groups
    @wish.author=@user #params[:user_id]
    create_wish(t("wish.from_author.views.added", title: @wish.title), t("wish.from_author.views.not_added", title: @wish.title)) or render 'new'
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
    save_wish(t("wish.from_author.views.updated", title: @wish.title), t("wish.from_author.views.not_updated", title: @wish.title)) or render 'edit'
  end    

  def destroy
    load_wish
    destroy_wish
    redirect_to user_my_wishes_url(@user)
  end 

  private

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
        redirect_to user_my_wish_url(@user,@wish) #WishFromDonee controller ::show
        true
      else  
        flash[:error]=msg_bad
        @user=@wish.user
        false
      end 
    end

    def create_wish(msg_ok,msg_bad)
      if @wish.save
        flash[:notice]=msg_ok
        redirect_to user_my_wish_url(@user,@wish) #WishFromDonee controller ::show
        true
      else  
        flash[:error]=msg_bad
        @user=@wish.author
        false
      end 
    end

    def destroy_wish
      if @wish.destroy(current_user)
        flash[:notice]=t("wish.from_author.views.deleted", title: @wish.title)
      else  
        flash[:error]=t("wish.from_author.views.not_deleted", title: @wish.title)
      end
    end  

    def wish_params
      unless defined?(@wish_params)
        if params[:wish_from_author].blank?
          @wish_params = {}
        else
          @wish_params=params[:wish_from_author]
          @wish_params[:donee_conn_ids]=[] if @wish_params[:donee_conn_ids]=="[]"
          @wish_params[:donee_conn_ids]=@wish_params[:donee_conn_ids].collect {|c| c.to_i}
          @wish_params[:donor_conn_ids]=[] if @wish_params[:donor_conn_ids]=="[]"
          @wish_params[:donor_conn_ids]=@wish_params[:donor_conn_ids].collect {|c| c.to_i}
        
          #The permitted scalar types are String, Symbol, NilClass, Numeric, TrueClass, FalseClass, Date, Time, DateTime, StringIO, IO, ActionDispatch::Http::UploadedFile and Rack::Test::UploadedFile.
          #To declare that the value in params must be an array of permitted scalar values map the key to an empty array:
          @wish_params = @wish_params.permit(:title, :description, donee_conn_ids: [],  donor_conn_ids: [])
        end  

      end
      @wish_params  
    end

    def wish_scope
      @user=current_user
      #here I can solve authorization to access objects
      #user can manage only it's own wishs
      @user.author_wishes
    end  

    def load_user_connections
      @user_connections=@user.connections
    end  

    def load_user_groups
      @user_groups=@user.groups.includes(:connections)
    end  


 

end
