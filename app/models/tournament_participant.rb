require "composite_primary_keys"

class TournamentParticipant < ActiveRecord::Base
  set_table_name :tournament_participants
  set_primary_keys :tournament_id, :user_id

  belongs_to :tournament, :foreign_key => :tournament_id
  belongs_to :participant, :foreign_key => :user_id
  
end
