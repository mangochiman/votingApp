class Participant < ActiveRecord::Base
  #set_table_name :participants
  #set_primary_key :participant_id
  set_table_name :users
  set_primary_key :user_id

  has_many :votes, :foreign_key => :user_id
end
