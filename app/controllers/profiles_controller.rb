class ProfilesController < ApplicationController

  def my
      @user=current_user

      if @user.email.match(User::Identity::TWITTER_FAKE_EMAIL_REGEXP)
        flash[:notice]=flash[:notice]
        flash[:warning]=flash[:warning]
        flash[:error]=flash[:error].to_s+" \n"+I18n.t("user.identities.twitter_do_not_send_email_address")
        redirect_to edit_user_registration_url(@user)
      end  
      @new_contact=User::Identity::AsContact.new(provider: User::Identity::LOCAL_PROVIDER, user: @user)
  end 
end
