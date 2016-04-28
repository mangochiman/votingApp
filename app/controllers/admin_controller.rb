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

  def edit_user
    @user = User.find(params[:user_id])
  end

  def update_user
    phone_number = params[:phone_number]
    first_name = params[:first_name]
    last_name = params[:last_name]
    nick_name = params[:nick_name]

    user = User.find(params[:user_id])
    user.phone_number = phone_number
    user.first_name = first_name
    user.last_name = last_name
    user.nick_name = nick_name
    user.save!

    flash[:notice] = "You have successfully updated details #{first_name} #{last_name}"
    redirect_to("/add_user") and return
  end

  def add_tournament
    @tournaments = Tournament.all

  end

  def create_tournament
    tournament_name = params[:name]
    start_date = params[:start_date]
    end_date = params[:end_date]
    sponsor = params[:sponsor]
    
    tournament = Tournament.new
    tournament.name = tournament_name
    tournament.start_date = start_date
    tournament.end_date = end_date
    tournament.sponsored_by = sponsor
    tournament.save

    flash[:notice] = "You have successfully added a new tournament"
    redirect_to("/add_tournament") and return
  end

  def edit_tournament
    @tournament = Tournament.find(params[:tournament_id])
  end

  def update_tournament
    tournament = Tournament.find(params[:tournament_id])
    tournament_name = params[:name]
    start_date = params[:start_date]
    end_date = params[:end_date]
    sponsor = params[:sponsor]
    tournament.name = tournament_name
    tournament.start_date = start_date
    tournament.end_date = end_date
    tournament.sponsored_by = sponsor
    tournament.save

    flash[:notice] = "You have successfully updated #{tournament_name}"
    redirect_to("/add_tournament") and return
  end
  
  def add_tournament_result

  end

  def add_participants

  end

  def add_competition

  end

end
