class MetaType < ActiveRecord::Base
self.table_name = 'invMetaTypes'

belongs_to :item, :primary_key=>'typeID', :foreign_key=>'typeID'
belongs_to :meta_group, :primary_key=>'metaGroupID', :foreign_key=>'metaGroupID'

def <=>(other)
	self.metaGroupID<=>other.metaGroupID
end

end
