class BaseBlueprint < ActiveRecord::Base
self.table_name = 'invBlueprintTypes'
self.primary_key = 'blueprintTypeID'

has_one :blueprint
belongs_to :item, :foreign_key=>'productTypeID'
has_many :ram_requirements, :foreign_key=>'typeID'
#has_many :products, :class_name=>:item, :through=>:ram_requirements

	# Only items required for production
def manufacturing_requirements
	RamRequirement.all(:conditions=>{:typeID=>self.blueprintTypeID,:activityID=>MANUFACTURING_ACTIVITY_ID}).to_a
end

# Only items required for research
def invention_requirements
	if self.item.parent_item
		rams = RamRequirement.all(:conditions=>{:typeID=>self.item.parent_item.base_blueprint.id,:activityID=>INVENTION_ACTIVITY_ID}).to_a
	else
		rams = Array.new
	end
	rams
end

# All materials, manufacturing requirements, and invention requirements for
# required for this item and all component items.
# This requires that this function be recusively run for each item it finds to
# account for multiple stages of a production chain.
def all_production_items
	items = Array.new
	self.item.materials.each do |mat|
		items.push mat.item
	end
	self.manufacturing_requirements.each do |ram|
		items.push ram.item
	end
	self.invention_requirements.each do |ram|
		items.push ram.item
	end
	items.each do |item|
		if item.base_blueprint
			items.concat item.base_blueprint.all_production_items
		else
			items.concat item.materials.map{|mat| mat.item }
		end
	end
	items.uniq
end

end
