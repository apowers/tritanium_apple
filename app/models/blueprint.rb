class Blueprint < ActiveRecord::Base

belongs_to :item
belongs_to :account

# Mirror some BaseBlueprint methods here for easier access
def productionTime
	self.item.base_blueprint.productionTime
end

def tech_level
	self.item.base_blueprint.techLevel.to_i
end

	# Only items required for production
def manufacturing_requirements
	self.item.base_blueprint.manufacturing_requirements
end

# Only items required for research
def invention_requirements
	self.item.base_blueprint.invention_requirements
end

def all_production_items
	self.item.base_blueprint.all_production_items
end

def production_efficiency
	if tech_level == 2 && !invention_requirements.empty?
		return -4
	else
		return 0
	end
end

def material_efficiency
	if tech_level == 2 && !invention_requirements.empty?
		return -4
	else
		return 0
	end
end

def waste_factor
	me = self.material_efficiency
	skill = 5
	if me < 0
		return 1 + ((1.0 * self.item.base_blueprint.wasteFactor / 100) * (1 - me)) * (1.2 - (0.04 * skill))
	else
		return 1 + ((1.0 * self.item.base_blueprint.wasteFactor / 100) * (1 / (1 + me))) * (1.2 - (0.04 * skill))
	end
end


# From http://games.chruker.dk/eve_online/invention_chance.php
# Base chance is 20% for battlecruisers, battleships, Hulk ( groupID = 419, 27, or itemID = 22544)
# Base chance is 25% for cruisers, industrials, Mackinaw ( groupID = 26, 28 or itemID = 22548)
# Base chance is 30% for frigates, destroyers, Skiff, freighters ( groupID = 25, 420, 513 or itemID = 22546)
# Base chance is 40% for all other items
def invention_chance
	base_chance = 0.0
	gid = self.item.groupID
	tid = self.item.typeID
	if gid == 27 || gid == 419 || tid == 22544
		base_chance = 0.2
	elsif gid == 26 || gid == 28 || tid == 22548
		base_chance = 0.25
	elsif gid == 25 || gid == 420 || gid == 513 || tid == 22546
		base_chance = 0.3
	else
		base_chance = 0.4
	end

# TODO determine which datacores are needed and the skill level associated with that datacore
#    character = Character.find(char_id)
#    encryption_skill_level = character.skill_level(...)
#    datacore_1_skill_level = character.skill_level(...)
#    datacore_2_skill_level = character.skill_level(...)
	encryption_skill_level = 3
	datacore_1_skill_level = 3
	datacore_2_skill_level = 3
	meta_level = 0
	decryptor_modifier = 1.0
	base_chance * (1.0 + (0.01 * encryption_skill_level)) * (1.0 + ((datacore_1_skill_level + datacore_2_skill_level) * (0.1 / (5.0 - meta_level)))) * decryptor_modifier
end

# It appears that ram requirements are not subject to waste. Need to verify.
def manufacturing_cost
	cost = 0.0
	self.item.materials.each do |mat|
		cost += ( (mat.quantity * waste_factor).round * mat.item.market_data.value )
	end
	self.manufacturing_requirements.each do |ram|
		next if ram.item.skill?
		cost += ( ram.quantity * ram.damagePerJob  * ram.item.market_data.value )
	end
	if self.tech_level == 2
		cost += self.invention_cost
	end
	cost /= self.item.portionSize
end

def invention_cost
	cost = 0.0
	invention_requirements.each do |ram|
		next if ram.item.data_interface?
		cost += ( ( ram.quantity * ram.item.market_data.value ) * invention_chance)
	end
	cost /= self.item.portionSize
end

end
