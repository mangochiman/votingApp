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
    @tournaments = Tournament.all
  end

  def add_my_tourney_result
    @tournament = Tournament.find(params[:tournament_id])
    @tournament_participants = User.all
  end

  def capture_tourney_results
    tournament_id = params[:tournament_id]
    ActiveRecord::Base.transaction do
      params[:participants].each do |participant_id, result|
        tournament_result = TournamentResult.new
        tournament_result.tournament_id = tournament_id
        tournament_result.participant_id = participant_id
        tournament_result.result = result
        tournament_result.save
      end
    end
    flash[:notice] = "Your operation is succeessful"
    redirect_to("/add_tournament_result ") and return
  end

  def select_tourney
    @tournament = Tournament.find(params[:tournament_id])
    @tournament_participants = @tournament.participants
  end

  def add_tourney_participants
    @tournament = Tournament.find(params[:tournament_id])
    @users = User.find_by_sql("SELECT u.* FROM users u LEFT JOIN tournament_participants tp ON u.user_id = tp.user_id
      AND tp.tournament_id = '#{params[:tournament_id]}' WHERE tp.tournament_id IS NULL")
  end

  def create_tourney_participants
    tournament_id = params[:tournament_id]
    ActiveRecord::Base.transaction do
      params[:user_ids].each do |user_id|
        tournament_participant = TournamentParticipant.new
        tournament_participant.user_id = user_id
        tournament_participant.tournament_id = tournament_id
        tournament_participant.save
      end
    end
    flash[:notice] = "Your operation is successful"
    redirect_to("/select_tourney/#{tournament_id} ") and return
  end

  def delete_participant_from_tourney
    tournament_id = params[:tournament_id]
    user_id = params[:userid]
    tournament_participant = TournamentParticipant.find(:first, :conditions => ["user_id =? AND tournament_id =?",
        user_id, tournament_id])
    tournament_participant.delete
    render :text => "true" and return
  end
  
  def add_participants

  end

  def add_competition

  end

end
