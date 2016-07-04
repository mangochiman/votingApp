require "composite_primary_keys"
class PredictionWinner < ActiveRecord::Base
  set_table_name :prediction_winners
  set_primary_keys :voter_id, :competition_id, :position

  belongs_to :competition, :foreign_key => :voting_type_id, :primary_key => :competition_id
  belongs_to :user, :foreign_key => :user_id, :primary_key => :voter_id

end
