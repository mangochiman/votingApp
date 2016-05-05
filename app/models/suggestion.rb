class Suggestion < ActiveRecord::Base
  set_table_name :suggestions
  set_primary_key :suggestion_id

  belongs_to :user, :foreign_key => :user_id
end
