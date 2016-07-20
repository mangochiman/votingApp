class Tracker < ActiveRecord::Base
  set_table_name :trackers
  set_primary_key :tracker_id

  belongs_to :user, :foreign_key => :user_id
end
