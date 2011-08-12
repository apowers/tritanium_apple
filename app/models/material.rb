class Material < ActiveRecord::Base
self.table_name = 'invTypeMaterials'
self.primary_key = 'typeID'

belongs_to :item, :primary_key=>'typeID', :foreign_key=>'typeID'
#has_many :assemblies, :class_name=>:items, :primary_key=>'typeID', :foreign_key=>'materialTypeID'

def item
	Item.find(self.materialTypeID)
end

end
