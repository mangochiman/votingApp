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
end
