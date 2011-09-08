class AccountsController < ApplicationController
  # GET /accounts
  # GET /accounts.xml
  def index
    @accounts = Account.all
  end

  # GET /accounts/1
  # GET /accounts/1.xml
  def show
    @account = Account.find(session[:account_id])
  end

  # GET /accounts/new
  # GET /accounts/new.xml
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
    @account = Account.find(params[:id])
  end

  # POST /accounts
  # POST /accounts.xml
  def create
		attrs = params[:account].merge Account::DEFAULT_ATTRIBUTES
    @account = Account.new(attrs)
		@account.password = Digest::SHA1.hexdigest(params[:account][:password])

		if @account.save
			session[:account_id] = @account.id
			redirect_to(@account, :notice => 'Account was successfully created.') and return
		else
			render :action => "new" and return
		end
  end

  # PUT /accounts/1
  # PUT /accounts/1.xml
  def update
    @account = Account.find(params[:id])
		@account.update_attributes(params[:account])

		if @account.save
			redirect_to(@account, :notice => 'Account was successfully updated.') and return
		else
			render :action => "edit" and return
		end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.xml
  def destroy
    @account = Account.find(params[:id])
    @account.destroy

		redirect_to(accounts_url)
  end

	def skills

	end

	
#-------------------------------------------
# Session Management

  def login
    if session[:account_id] && session[:account_id] > 1
      redirect_to accounts_path and return
    end
		if params[:username].blank? || params[:password].blank?
			return
		end
    @account = Account.where(:username=>params[:username]).first
    passdigest = Digest::SHA1.hexdigest(params[:password])
    if !@account.blank? && passdigest == @account.password
      session[:account_id] = @account.id
      redirect_to @account and return
    else
      flash[:notice] = "Login failed."
      redirect_to '/login' and return
    end
  end

	def logout
    reset_session
    flash[:notice] = "Logged Out"
    redirect_to '/login'
	end

end
