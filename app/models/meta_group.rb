class MetaGroup < ActiveRecord::Base
self.table_name = 'invMetaGroups'
self.primary_key = 'metaGroupID'

has_many :meta_types, :foreign_key=>'metaGroupID'

def <=>(other)
	self.metaGroupName<=>other.metaGroupName
end

def items
	i = Array.new
	self.meta_types.each do |m|
		i.push Item.find(m.typeID)
	end
	i
end

end
