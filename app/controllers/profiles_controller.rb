class ProfilesController < ApplicationController
  def my
      @user= current_user
  end 
end
