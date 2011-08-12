class Category < ActiveRecord::Base
self.table_name = "invCategories"
self.primary_key = "categoryID"

has_one :item, :through=>:groups

def <=>(other)
	self.categoryName <=> other.categoryName
end
def name
	self.categoryName
end

end
