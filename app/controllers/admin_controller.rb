class AdminController < ApplicationController
  before_filter :admin_is_required
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

    if params[:admin].upcase == 'YES'
      role = 'admin'
    else
      role = 'user'
    end

    user_role = UserRole.new
    user_role.user_id = user.user_id
    user_role.role = role
    user_role.save
    
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

    if params[:admin].upcase == 'YES'
      role = 'admin'
    else
      role = 'user'
    end
    ActiveRecord::Base.transaction do
      user_role = user.user_roles.last
      user_role.delete unless user_role.blank?
      
      user_role = UserRole.new
      user_role.user_id = params[:user_id]
      user_role.role = role
      user_role.save
    end
    
    
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
    tournament.open_for_votes = false
    tournament.save

    flash[:notice] = "You have successfully added a new tournament"
    redirect_to("/add_tournament") and return
  end

  def enable_tournament_for_predictions
    tournament = Tournament.find(params[:tournament_id])
    tournament.open_for_votes = true
    tournament.save
    render :text => true and return
  end

  def disable_tournament_for_predictions
    tournament = Tournament.find(params[:tournament_id])
    tournament.open_for_votes = false
    tournament.save
    render :text => true and return
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
    @tournament_participants = @tournament.participants
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
    @tournament_competitions = @tournament.competitions
  end

  def add_tourney_participants
    @tournament = Tournament.find(params[:tournament_id])
    @users = User.find_by_sql("SELECT u.* FROM users u LEFT JOIN tournament_participants tp ON u.user_id = tp.user_id
      AND tp.tournament_id = '#{params[:tournament_id]}' WHERE tp.tournament_id IS NULL")
  end

  def add_tourney_competitions
    @tournament = Tournament.find(params[:tournament_id])
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

  def create_tourney_competitions
    competition_name = params[:competition_name]
    max_votes = params[:max_votes]
    start_date = params[:start_date]
    end_date = params[:end_date]
    description = params[:description]
    tournament_id = params[:tournament_id]
    
    competition = Competition.new
    competition.name = competition_name
    competition.tournament_id = tournament_id
    competition.max_votes = max_votes
    competition.start_date = start_date
    competition.end_date = end_date
    competition.description = description
    competition.save

    flash[:notice] = "Your operation is successful"
    redirect_to("/select_tourney/#{tournament_id} ") and return
  end

  def edit_tourney_competition
    @competition = Competition.find(params[:competition_id])
  end

  def update_tourney_competition
    competition_name = params[:competition_name]
    max_votes = params[:max_votes]
    start_date = params[:start_date]
    end_date = params[:end_date]
    description = params[:description]
    tournament_id = params[:tournament_id]

    competition = Competition.find(params[:competition_id])
    competition.name = competition_name
    #competition.tournament_id = tournament_id
    competition.max_votes = max_votes
    competition.start_date = start_date
    competition.end_date = end_date
    competition.description = description
    competition.save

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

  def delete_competition_from_tourney
    tournament_competition = Competition.find(params[:competition_id])
    tournament_competition.delete
    render :text => "true" and return
  end
  
  def add_participants
    @tournaments = Tournament.all
  end

  def add_competition
    @tournaments = Tournament.all
  end

  def suggestions
    @suggestions = Suggestion.find(:all, :order => 'created_at DESC')
  end

  def tournament_details
    @tournament = Tournament.find(params[:tournament_id])
    @competition_hash = {}
    @users = {}
    @competition_and_voters = {}
    @competition_and_winners = {}

    user_ids = []
    @tournament.competitions.each do |competition|
      @competition_hash[competition.voting_type_id] = competition.name
      competition_id = competition.voting_type_id

      competition.prediction_winners.each do |prediction_winner|
        user =  prediction_winner.user
        next if user.blank?
        position = prediction_winner.position
        user_ids << user.user_id
        @competition_and_winners[competition_id] = {} if @competition_and_winners[competition_id].blank?
        @competition_and_winners[competition_id][position] = {}
        @competition_and_winners[competition_id][position]["first_name"] = user.first_name
        @competition_and_winners[competition_id][position]["last_name"] = user.last_name
        @competition_and_winners[competition_id][position]["nick_name"] = user.nick_name
        @competition_and_winners[competition_id][position]["user_id"] = user.user_id
      end

      @competition_and_voters[competition_id] = {} if @competition_and_voters[competition_id].blank?
      competition.votes.each do |vote|
        next if vote.user.blank?
        user = vote.user
        user_id = user.user_id
        next if user_ids.include?(user_id)
        @competition_and_voters[competition_id][user_id] = {} if @competition_and_voters[competition_id][user_id].blank?
        @competition_and_voters[competition_id][user_id]["first_name"] = user.first_name
        @competition_and_voters[competition_id][user_id]["last_name"] = user.last_name
        @competition_and_voters[competition_id][user_id]["nick_name"] = user.nick_name
      end

    end


    User.all.each do |user|
      @users[user.user_id] = user.first_name.to_s + " " + user.last_name.to_s
    end

  end
  
end
