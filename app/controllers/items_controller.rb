class ItemsController < ApplicationController
  # GET /items
  # GET /items.xml
  def index
		if params[:name]
      @groups = Array.new
      @items = Item.find(:all,:conditions=>["typeName LIKE ?", "%#{params[:name]}%"]).sort
#      @items = Item.where(["typeName LIKE ?", "%#{params[:name]}%"]).sort
			if @items.size == 1
				redirect_to @items[0] and return
			end
		elsif params[:id]
			@groups = MarketGroup.find(:all, :conditions=>{:parentGroupID=>params[:id]}).sort
			@items = Item.find(:all,:conditions=>{:marketGroupID=>params[:id]}).sort
			@current_group = MarketGroup.find(params[:id])
		else
			@groups = MarketGroup.find(:all, :conditions=>{:parentGroupID=>nil}).sort
			@items = Array.new
			@current_group = nil
		end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @items }
    end
  end

  # GET /items/1
  # GET /items/1.xml
  def show
    @item = Item.find(params[:id])
		@item.update_market_data
		@item_md = @item.market_data(true)
		@item_bp = @item.blueprint(true)
		@item_assemblies = @item.assemblies

		# Split manufacturing requirements into skills and items
		if @item_bp
			@item_mr_skills = Array.new
			@item_mr_items = Array.new
			@item_bp.manufacturing_requirements.each do |ram|
				if ram.item.skill?
					@item_mr_skills.push ram
				else
					@item_mr_items.push ram
				end
			end
		end

		# Splint invention requirements into consumables and non-consumables
		if @item.parent_item && @item_bp
			@item_inv_skills = Array.new
			@item_inv_items = Array.new
			@item_bp.invention_requirements.each do |ram|
				if ram.item.skill?
					@item_inv_skills.push ram
				else
					@item_inv_items.push ram
				end
			end
		end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item }
    end
  end

end
