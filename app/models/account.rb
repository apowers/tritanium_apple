class Account < ActiveRecord::Base

	has_many :blueprints

	validates_presence_of :username
	validates_presence_of :password
	validates_format_of :username, :with => /\A[a-zA-Z][-\w]+[a-zA-Z]\Z/, :message=>"has invalid characters."
	validates_uniqueness_of :username, :scope=>:username, :case_sensitive=>false
	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

	DEFAULT_ATTRIBUTES = {
	#	:region_id => 10000002,
	:api_key => 0,
	#	:corporation_id => nil,
	:eve_id => 0,
	#	:character_name => "none",
	}

end
