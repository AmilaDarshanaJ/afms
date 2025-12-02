class UsersController < ApplicationController
  allow_unauthenticated_access only: [] # Lock everything down by default
  before_action :require_admin!
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all.order(created_at: :asc) # Added order for better list view
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

  # --- NEW: Edit Action ---
  # This renders the form with existing data
  def edit
  end

  # --- NEW: Update Action ---
  # This saves the changes to the database
  def update
    if @user.update(user_params)
      redirect_to users_path, notice: "User details updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user == Current.user
      redirect_to users_path, alert: "You cannot delete yourself!"
    else
      @user.destroy
      redirect_to users_path, notice: "User deleted."
    end
  end

  private

  # Use this callback to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    # Get the permitted params
    permitted = params.require(:user).permit(:email_address, :password, :password_confirmation, :role)

    # CRITICAL: If password fields are left blank, remove them from the params.
    # This allows you to update a Role without resetting the user's password.
    if permitted[:password].blank?
      permitted.delete(:password)
      permitted.delete(:password_confirmation)
    end

    permitted
  end

  def require_admin!
    unless Current.user&.admin?
      redirect_to root_path, alert: "Access Denied."
    end
  end
end