class VotingType < ActiveRecord::Base
  set_table_name :voting_types
  set_primary_key :voting_type_id

  has_many :votes, :foreign_key => :voting_type_id
  belongs_to :tournament, :foreign_key => :tournament_id
end
