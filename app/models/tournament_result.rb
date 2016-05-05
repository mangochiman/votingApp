class TournamentResult < ActiveRecord::Base
  set_table_name :tournament_results
  set_primary_key :tournament_result_id

  belongs_to :tournament, :foreign_key => :tournament_id
  belongs_to :participant, :foreign_key => :participant_id
end
