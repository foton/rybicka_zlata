class PeopleController < ApplicationController
	def index 
	  load_people
	end  

	def show
	  load_person
	end 

	def new
	  build_person
	end 

  def create
    build_person
    save_person or render template: "profiles/my"
	end

	def edit
	 load_person
	 build_person
	end  

	def update
	 load_person
	 build_person
	 save_person or render 'edit'
	end    

	def destroy
    load_person
    destroy_person
    redirect_to my_page_url
	end	

  private

    def load_people
      @people||=person_scope
    end  

    def load_person
      @person||=person_scope.find(params[:id]) 
    end 

    def build_person
      @person||=person_scope.build
      @person.attributes=person_params     
      @person.user_id=current_user.id #params[:user_id]
    end	

    def save_person
      if @person.save
        flash[:notice]=t("user.contacts.added", contact: @person.to_s)
        redirect_to my_page_url
        true
      else  
        flash[:error]=t("user.contacts.not_added", contact: @person.to_s)
        @new_contact=@person
        @user=@person.user
        false
      end 
    end

    def destroy_person
      if @person.destroy
        flash[:notice]=t("user.contacts.deleted", contact: @person.to_s)
      else  
        flash[:error]=t("user.contacts.not_deleted", contact: @person.to_s)
      end
    end  

    def person_params
      person_params = params[:user_person]
      person_params ? person_params.permit(:email, :provider) : {}
    end

    def person_scope
      #here I can solve authorization to access objects
      #user can manage only it's own people
      Person.where(user_id: current_user.id)
    end  

   
end

end