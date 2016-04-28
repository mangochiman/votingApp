require "composite_primary_keys"

class TournamentParticipant < ActiveRecord::Base
  set_table_name :tournament_participants
  set_primary_keys :tournament_id, :participant_id

  belongs_to :tournament, :foreign_key => :tournament_id
end
