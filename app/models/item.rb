class Item < ActiveRecord::Base
self.table_name = "invTypes"
self.primary_key = "typeID"

has_one :blueprint
has_one :base_blueprint, :foreign_key=>'productTypeID'
has_many :materials, :foreign_key=>'typeID'
has_many :meta_groups, :through=>:meta_types
has_one :meta_type, :foreign_key=>'typeID'
has_many :meta_variants, :class_name=>'MetaType', :foreign_key=>'parentTypeID'
has_one :market_data
belongs_to :group, :foreign_key=>'groupID'
has_one :category, :through=>:group

def name
	self.typeName
end

def <=>(other)
	self.typeName <=> other.typeName
end

def skill?
	self.category.id == SKILL_CATEGORY_ID
end

def tool?
	self.groupID == TOOL_GROUP_ID
end

def ship?
	self.category.id == SKILL_CATEGORY_ID
end

def blueprint?
	self.category.id == BLUEPRINT_CATEGORY_ID
end

def data_interface?
	self.groupID == DATA_INTERFACE_GROUP_ID
end

def mineral?
	self.groupID == MINERAL_GROUP_ID
end

def parent_group
	MarketGroup.find(self.marketGroupID)
end

def parent_item
	Item.find((MetaType.where(:typeID=>self.typeID).first).parentTypeID)
rescue
	nil
end

def blueprint_record
	if self.blueprint.nil?
		bp = Blueprint.new
		bp.item = self
		bp.save
	end
	self.blueprint(true)
end

# update market data for this item and all components in one batch
# Because we update the entire compenents tree at the same time, we know
# if any of them need to be updated if myself has expired.
def update_market_data
	items = [self]
	self.materials.each {|m| items.push m.item}
	if self.base_blueprint
		items.concat self.blueprint_record.all_production_items
#		blueprint_record && ( items.concat self.base_blueprint.all_production_items )
	end
	MarketData.update_items(items.uniq)
end

def reprocess_value
	value = 0.0
	self.materials.each do |mat|
		value += ( mat.quantity * mat.item.market_data.value )
	end
	value /= self.portionSize
end

# Items which require this item as a component part
def assemblies
	prods = Array.new
	Material.where(:materialTypeID=>self.id).each do |mat|
		prods.push mat.item
	end
	RamRequirement.where(:activityID=>MANUFACTURING_ACTIVITY_ID,:requiredTypeID=>self.id).each do |ram|
		prods.push ram.base_blueprint.item
	end
	prods.uniq.sort
end

end
