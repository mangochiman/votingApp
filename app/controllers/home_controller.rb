class HomeController < ApplicationController
  before_filter :admin_is_required, :only => [:home]
  def home
    @tournaments = Tournament.find(:all, :order => "start_date DESC", :limit => 10)
    @all_tournaments = Tournament.all
    @recent_votes = Vote.find(:all, :order => 'created_at DESC', :group => 'user_id, voting_type_id').collect{|v|v.user}.compact
  end

  def voter
    @competition_and_voters = {}
    @users = {}
    @competitions = Competition.all
    @competition_and_winners = {}

    @competitions.each do |competition|
      competition_id = competition.voting_type_id
      @competition_and_voters[competition_id] = {} if @competition_and_voters[competition_id].blank?
      competition.votes.each do |vote|
        next if vote.user.blank?
        user = vote.user
        user_id = user.user_id

        participant = User.find(vote.participant_id) rescue nil

        @competition_and_voters[competition_id][user_id] = {} if @competition_and_voters[competition_id][user_id].blank?
        @competition_and_voters[competition_id][user_id]["participants"] = [] if @competition_and_voters[competition_id][user_id]["participants"].blank?
        @competition_and_voters[competition_id][user_id]["first_name"] = user.first_name
        @competition_and_voters[competition_id][user_id]["last_name"] = user.last_name
        @competition_and_voters[competition_id][user_id]["nick_name"] = user.nick_name
        @competition_and_voters[competition_id][user_id]["participants"] << (participant.nick_name rescue 'Deleted')
      end

      competition.prediction_winners.each do |prediction_winner|
        user =  prediction_winner.user
        next if user.blank?
        position = prediction_winner.position
        @competition_and_winners[competition_id] = {} if @competition_and_winners[competition_id].blank?
        @competition_and_winners[competition_id][position] = {}
        @competition_and_winners[competition_id][position]["first_name"] = user.first_name
        @competition_and_winners[competition_id][position]["last_name"] = user.last_name
        @competition_and_winners[competition_id][position]["nick_name"] = user.nick_name
        @competition_and_winners[competition_id][position]["user_id"] = user.user_id
      end

    end

    User.all.each do |user|
      @users[user.user_id] = user.first_name.to_s + " " + user.last_name.to_s
    end

    @user = session[:user]
    render :layout => "voter"
  end

  def new_suggestions
    user = User.find(session[:user])
    @suggestions = user.suggestions
    render :layout => "voter"
  end

  def predictions
    @competition = Competition.find(params[:competition_id])
    @my_predictions = session[:user].votes.find(:all, :conditions => ["voting_type_id =?", 
        params[:competition_id]]).collect{|v|v.participant}.compact

    user_ids = @my_predictions.map(&:user_id)
    user_ids = [0] if user_ids.blank?
    @tournament_participants  = @competition.tournament.participants.find(:all, :conditions => ["tournament_participants.user_id NOT IN (?)", user_ids])
    render :layout => "voter"
  end

  def create_votes
    competition_id = params[:competition_id]
    user_id = session[:user].user_id
    ActiveRecord::Base.transaction do
      params[:participant_ids].each do |participant|
        vote = Vote.new
        vote.user_id = user_id
        vote.participant_id = participant
        vote.voting_type_id = competition_id
        vote.created_at = Time.now
        vote.updated_at = Time.now
        vote.save
      end
    end

    flash[:notice] = "Thanks for making your predictions"
    redirect_to("/voter") and return
  end

  def view_tournament
    @tournament = Tournament.find(params[:tournament_id])
    @competition_hash = {}
    @users = {}
    @competition_and_winners = {}

    @tournament.competitions.each do |competition|
      @competition_hash[competition.voting_type_id] = competition.name
      competition_id = competition.voting_type_id

      competition.prediction_winners.each do |prediction_winner|
        user =  prediction_winner.user
        next if user.blank?
        position = prediction_winner.position
        @competition_and_winners[competition_id] = {} if @competition_and_winners[competition_id].blank?
        @competition_and_winners[competition_id][position] = {}
        @competition_and_winners[competition_id][position]["first_name"] = user.first_name
        @competition_and_winners[competition_id][position]["last_name"] = user.last_name
        @competition_and_winners[competition_id][position]["nick_name"] = user.nick_name
        @competition_and_winners[competition_id][position]["user_id"] = user.user_id
      end
      
    end
    
    
    User.all.each do |user|
      @users[user.user_id] = user.first_name.to_s + " " + user.last_name.to_s
    end

    render :layout => 'voter'
  end

  def render_tournament_participants
    tournament = Tournament.find(params[:tournament_id])
    participants = tournament.participants
    data = {}

    participants.each do |participant|
      participant_id = participant.user_id
      data[participant_id] = {}
      data[participant_id]["first_name"] = participant.first_name
      data[participant_id]["last_name"] = participant.last_name
      data[participant_id]["nick_name"] = participant.nick_name
      data[participant_id]["phone_number"] = participant.phone_number
    end
    
    render :text => data.to_json and return
  end

  def render_tournament_results
    tournament = Tournament.find(params[:tournament_id])
    tournament_results = tournament.tournament_results
    participants = tournament.participants

    data = {}
    
    tournament_results.each do |tournament_result|
      participant = tournament_result.participant
      participants  = participants - [participant]
      participant_id = participant.user_id
      data[participant_id] = {}
      data[participant_id]["first_name"] = participant.first_name
      data[participant_id]["last_name"] = participant.last_name
      data[participant_id]["nick_name"] = participant.nick_name
      data[participant_id]["phone_number"] = participant.phone_number
      data[participant_id]["result"] = tournament_result.result
    end

    participants.each do |participant|
      participant_id = participant.user_id
      data[participant_id] = {}
      data[participant_id]["first_name"] = participant.first_name
      data[participant_id]["last_name"] = participant.last_name
      data[participant_id]["nick_name"] = participant.nick_name
      data[participant_id]["phone_number"] = participant.phone_number
      data[participant_id]["result"] = "??"
    end
    
    render :text => data.to_json and return
  end

  def render_tournament_predictions
    tournament = Tournament.find(params[:tournament_id])
    tournament_competitions = tournament.competitions

    data = {}
    tournament_competitions.each do |competition|
      competition_id = competition.voting_type_id
      data[competition_id] = {}
      competition.votes.each do |vote|
        user = User.find(vote.user_id) rescue nil
        next if user.blank?
        voter = vote.user_id
        participant_id = vote.participant_id

        data[competition_id][voter] = [] if data[competition_id][voter].blank?
        data[competition_id][voter] << participant_id
      end
    end

    render :text => data.to_json and return
  end

  def withdraw_from_competition
    user = session[:user]
    competition_id = params[:competition_id]
    user_votes = user.votes.find(:all, :conditions => ["voting_type_id =?", competition_id])
    ActiveRecord::Base.transaction do
      user_votes.each do |vote|
        vote.delete
      end
    end
    render :text => true and return
  end

  def create_suggestions
    title = params[:title]
    data = params[:data]
    user_id = session[:user].user_id

    suggestion = Suggestion.new
    suggestion.title = title
    suggestion.data = data
    suggestion.user_id = user_id
    suggestion.save!

    flash[:notice] = "Thanks for your suggestions. We will look at them shortly"
    redirect_to("/new_suggestions")
  end

  def edit_suggestion
    @suggestion = Suggestion.find(params[:suggestion_id])
  end

  def update_suggestion
    title = params[:title]
    data = params[:data]
    suggestion = Suggestion.find(params[:suggestion_id])
    suggestion.title = title
    suggestion.data = data
    suggestion.save!
    flash[:notice] = "You have successfully edited your suggestion. We will look at it shortly"
    redirect_to("/new_suggestions") and return
  end

  def delete_suggestion
    suggestion = Suggestion.find(params[:suggestion_id])
    suggestion.delete
    render :text => "true" and return
  end

  def create_winners
    tournament_id = params[:tournament_id]
    competition_id = params[:competition_id]
    
    position = 1
    ActiveRecord::Base.transaction do
      old_winners = PredictionWinner.find(:all, :conditions => ["competition_id =?", competition_id])
      old_winners.each do |old_winner|
        old_winner.delete
      end
      params[:winners_ids].each do |winner_id|
        prediction_winner = PredictionWinner.new
        prediction_winner.voter_id = winner_id
        prediction_winner.competition_id = competition_id
        prediction_winner.position = position
        prediction_winner.created_at = Time.now
        prediction_winner.updated_at = Time.now
        prediction_winner.save
        position = position + 1
      end
    end

    redirect_to("/tournament_details/#{tournament_id}")
  end
  
end
