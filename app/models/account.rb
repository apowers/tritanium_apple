class Account < ActiveRecord::Base

	has_many :blueprints
#	has_many :skills

	validates_presence_of :username
	validates_presence_of :password
	validates_format_of :username, :with => /\A[a-zA-Z][-\w]+[a-zA-Z0-9]\Z/, :message=>"is invalid."
	validates_uniqueness_of :username, :scope=>:username, :case_sensitive=>false
	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
	validates_uniqueness_of :email, :scope=>:email, :case_sensitive=>false
	
	DEFAULT_ATTRIBUTES = {
	#	:region_id => 10000002,
	:api_key => 0,
	#	:corporation_id => nil,
	:eve_id => 0,
	#	:character_name => "none",
	}

end
