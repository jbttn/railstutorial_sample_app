class UsersController < ApplicationController
  
  def new
    @user = User.new
    @title = "Sign up"
  end

  def show
    @user = User.find_by_id(params[:id])
    @title = @user.name
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      # flash[:success] = "Welcome to the Sample App!"
      redirect_to user_path(@user),
        :flash => { :success => "Welcome to the Sample App!" }
    else
      @title = "Sign up"
      render 'new'
    end
  end
  
end
