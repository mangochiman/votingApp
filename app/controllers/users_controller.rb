class UsersController < ApplicationController
  def login
    render :layout => false
  end

  def logout
    redirect_to("/login")
  end

  def user_profile
    render :layout => false
  end
  
end
