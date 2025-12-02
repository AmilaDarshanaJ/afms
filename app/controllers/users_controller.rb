class UsersController < ApplicationController
  allow_unauthenticated_access only: [] # Lock everything down by default
  before_action :require_admin!

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: "User created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])

    if @user == Current.user
      redirect_to users_path, alert: "You cannot delete yourself!"
    else
      @user.destroy
      redirect_to users_path, notice: "User deleted."
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation, :role)
  end

  def require_admin!
    unless Current.user&.admin?
      redirect_to root_path, alert: "Access Denied."
    end
  end
end