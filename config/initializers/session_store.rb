# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_votingApp_session',
  :secret      => '923bfb1d77bb034aafd4ebdfe1fe84becec445aa8b8bcb136025f3f7d3c73249941500601531e8076d24020de19eb18a47aa37a83b3b540b304dbfd9bb91e3ef'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
