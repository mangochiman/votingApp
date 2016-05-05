class HomeController < ApplicationController
  def home
    @tournaments = Tournament.find(:all, :order => "start_date DESC", :limit => 10)
    @all_tournaments = Tournament.all
  end

  def voter
    @competitions = Competition.all
    render :layout => "voter"
  end

  def new_suggestions
    render :layout => "voter"
  end

  def predictions
    @competition = Competition.find(params[:competition_id])
    @tournament_participants  = @competition.tournament.participants
    render :layout => "voter"
  end

  def create_votes
    competition_id = params[:competition_id]
    user_id = 111
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
    data = {}
    
    tournament_results.each do |tournament_result|
      participant = tournament_result.participant
      participant_id = participant.user_id
      data[participant_id] = {}
      data[participant_id]["first_name"] = participant.first_name
      data[participant_id]["last_name"] = participant.last_name
      data[participant_id]["nick_name"] = participant.nick_name
      data[participant_id]["phone_number"] = participant.phone_number
      data[participant_id]["result"] = tournament_result.result
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
        voter = vote.user_id
        participant_id = vote.participant_id

        data[competition_id][voter] = [] if data[competition_id][voter].blank?
        data[competition_id][voter] << participant_id
      end
    end

    render :text => data.to_json and return
  end
  
end
