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
  
end
