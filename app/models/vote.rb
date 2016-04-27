require "composite_primary_keys"

class Vote < ActiveRecord::Base
  set_table_name :votes
  set_primary_keys :user_id, :participant_id, :voting_type_id
end
