class Tournament < ActiveRecord::Base
  set_table_name :tournaments
  set_primary_key :tournament_id

  has_many :tournament_participants, :foreign_key => :tournament_id
  has_many :participants, :through => :tournament_participants
  has_many :tournament_results, :foreign_key => :tournament_id
  has_many :voting_types, :foreign_key => :tournament_id
  
end
