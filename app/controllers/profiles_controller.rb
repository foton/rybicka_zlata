class ProfilesController < ApplicationController
  def my
      @user=current_user
      @new_contact=User::Identity::AsContact.new(provider: User::Identity::LOCAL_PROVIDER, user: @user)
  end 
end
