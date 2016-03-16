class ProfilesController < ApplicationController
  before_filter :set_user, except: [:my]

  def my
    @user=current_user
    show
  end 

  def show
    if @user.email.match(User::Identity::TWITTER_FAKE_EMAIL_REGEXP)
      flash[:notice]=flash[:notice]
      flash[:warning]=flash[:warning]
      flash[:error]=flash[:error].to_s+" \n"+I18n.t("user.identities.twitter_do_not_send_email_address")
      redirect_to edit_user_registration_url(@user)
    end  
    @new_contact=User::Identity::AsContact.new(provider: User::Identity::LOCAL_PROVIDER, user: @user)
    render :show
  end  

  private

    def not_peeking_url
        url_for(action: :my, params: {locale: I18n.locale})  
    end 

end
