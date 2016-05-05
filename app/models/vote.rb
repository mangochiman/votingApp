require "composite_primary_keys"

class Vote < ActiveRecord::Base
  set_table_name :votes
  #set_primary_keys :user_id, :participant_id, :voting_type_id
  set_primary_keys :user_id, :voting_type_id
  belongs_to :user, :foreign_key => :user_id
  belongs_to :participant, :foreign_key => :participant_id
  belongs_to :voting_type, :foreign_key => :voting_type_id
end
