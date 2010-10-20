class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update, :index]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  
  def new
    @title = 'Sign up'
    @user = User.new
  end

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
    store_location #so destroying can go back to this page
  end

  def show
    if (params[:id].to_i.nonzero?)
      @user = User.find(params[:id])
    else
      @user = User.find_by_name(params[:name].downcase)
    end
    if (@user.nil?)
      redirect_to "/"
    else
      @title = @user.name
    end
  end

  def create
    @attr = params[:user]
    @attr = @attr.merge(:name => @attr[:name].downcase)
    @user = User.new(@attr)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to "/#{@user.name}"
      #redirect_to users_path(@user)

    else
      @title = "Sign up"
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end

  def edit
    @title = "Edit user"
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed"
    redirect_back_or users_path
  end

  private

    def authenticate
      deny_access unless signed_in?
    end
      
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
