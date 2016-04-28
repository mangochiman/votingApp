class AdminController < ApplicationController
  def settings

  end

  def add_user
    @users = User.all
  end

  def create_user
    phone_number = params[:phone_number]
    first_name = params[:first_name]
    last_name = params[:last_name]
    nick_name = params[:nick_name]

    user = User.new
    user.phone_number = phone_number
    user.first_name = first_name
    user.last_name = last_name
    user.nick_name = nick_name
    user.save!

    flash[:notice] = "You have successfully added a new user"
    redirect_to("/add_user") and return
  end

  def add_tournament

  end

  def add_tournament_result

  end

  def add_participants

  end

  def add_competition

  end

end
