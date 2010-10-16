class UsersController < ApplicationController
  def new
    @title = 'Sign up'
    @user = User.new
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
end
