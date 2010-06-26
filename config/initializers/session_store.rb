# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_Tritanium Apple_session',
  :secret      => 'f62a6cd3fa917211ecec41ff958341b9c3fae3cb8cc607a296bc3461865e03c6ca8555965a180b47494d3a65c240f3040aca5b6c84a068ff9ed12385335bac6f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
