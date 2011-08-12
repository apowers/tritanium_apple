class MarketData < ActiveRecord::Base
require 'net/http'
require 'hpricot'

belongs_to :item

# A shortcut to the presumed value of an item
def value
	self.combined_median || 1
end

# A class method to update lots of items in a single operation
def self.update_items(items,region_id=0)
  items_query = ""
  items.uniq.each do |item|
		if item.market_data.nil? || item.market_data.expired?
			items_query += "typeid=#{item.typeID}&"
		else
			items.delete item
		end
	end
	return if items.empty?
	
  eve_central_query = "http://api.eve-central.com/api/marketstat?#{items_query}"
  eve_central_query += "regionlimit=#{region_id}" unless region_id == 0
  eve_central_result = String.new

	# Sometimes this query times-out, so wrap it in a begin/end block.
	begin
		eve_central_result = Net::HTTP.get(URI.parse(eve_central_query))
		eve_central_data = Hpricot::XML(eve_central_result)
		items.each do |item|
			item_data = eve_central_data.search("//type[@id=#{item.typeID}]")
			if item_data
				ic = item.market_data
				if ic.nil?
					ic = MarketData.new
					ic.item = item
				end
				ic.combined_volume = (item_data/"all/volume").inner_html.to_f * MARKET_VOLUME_RATIO || ic.combined_volume
				ic.combined_mean = (item_data/"all/avg").inner_html					|| ic.combined_mean
				ic.combined_max = (item_data/"all/max").inner_html					|| ic.combined_max
				ic.combined_min = (item_data/"all/min").inner_html					|| ic.combined_min
				ic.combined_deviation = (item_data/"all/stddev").inner_html || ic.combined_deviation
				ic.combined_median = (item_data/"all/median").inner_html		|| ic.combined_median
				ic.buy_volume = (item_data/"buy/volume").inner_html.to_f * MARKET_VOLUME_RATIO || ic.buy_volume
				ic.buy_mean = (item_data/"buy/avg").inner_html							|| ic.buy_mean
				ic.buy_max = (item_data/"buy/max").inner_html								|| ic.buy_max
				ic.buy_min = (item_data/"buy/min").inner_html							  || ic.buy_min
				ic.buy_deviation = (item_data/"buy/stddev").inner_html			|| ic.buy_deviation
				ic.buy_median = (item_data/"buy/median").inner_html					|| ic.buy_median
				ic.sell_volume = (item_data/"sell/volume").inner_html.to_f * MARKET_VOLUME_RATIO || ic.sell_volume
				ic.sell_mean = (item_data/"sell/avg").inner_html						|| ic.sell_mean
				ic.sell_max = (item_data/"sell/max").inner_html							|| ic.sell_max
				ic.sell_min = (item_data/"sell/min").inner_html							|| ic.sell_min
				ic.sell_deviation = (item_data/"sell/stddev").inner_html		|| ic.sell_deviation
				ic.sell_median = (item_data/"sell/median").inner_html				|| ic.sell_median
				ic.save
			end
		end
	rescue Timeout::Error
	end
end

# Cached data after 3am each day.
# Data is expired if the year day or year are less than today or the hour less than 3am.
def expired?
	#self.updated_at < ( Time.now - 6.hours )
	self.updated_at.yday < Time.now.yday || self.updated_at.year < Time.now.year || self.updated_at.hour < 3
rescue
	true
end

end
