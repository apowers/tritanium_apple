class RamRequirement < ActiveRecord::Base
self.table_name = "ramTypeRequirements"

belongs_to :base_blueprint, :primary_key=>'blueprintTypeID', :foreign_key=>'typeID'
belongs_to :item, :primary_key=>'typeID', :foreign_key=>'requiredTypeID'
#belongs_to :product, :class_name=>:base_blueprint, :primary_key=>'requiredTypeID', :foreign_key=>'typeID'

end
