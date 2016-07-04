require "composite_primary_keys"
class PredictionWinner < ActiveRecord::Base
  set_table_name :prediction_winners
  set_primary_keys :voter_id, :competition_id, :position

  has_one :competition, :foreign_key => :voting_type_id, :primary_key => :competition_id
  has_one :user, :primary_key => :voter_id, :foreign_key => :user_id

end
