class MarketGroup < ActiveRecord::Base
self.table_name = "invMarketGroups"
self.primary_key = "marketGroupID"

def <=>(other)
	self.marketGroupName <=> other.marketGroupName
end
def name
	self.marketGroupName
end
def parent
	MarketGroup.find(self.parentGroupID)
end

end
