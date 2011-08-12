class Group < ActiveRecord::Base
self.table_name = "invGroups"
self.primary_key = "groupID"

has_one :item, :primary_key=>'groupID'
belongs_to :category, :foreign_key=>'categoryID'

def <=>(other)
	self.groupName <=> other.groupName
end
def name
	self.groupName
end

end
