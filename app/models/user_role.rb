require "composite_primary_keys"

class UserRole < ActiveRecord::Base
  set_table_name :user_roles

  set_primary_keys :user_id, :role
  belongs_to :user, :foreign_key => :user_id

end
