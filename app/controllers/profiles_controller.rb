class ProfilesController < ApplicationController
  # Ensure only logged-in users can see this
  # (Adjust this line based on your specific auth setup, e.g., before_action :authenticate_user!)

  def show
    @user = Current.user
  end

  def edit
    @user = Current.user
  end

  def update
    @user = Current.user
    if @user.update(profile_params)
      redirect_to profile_path, notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end
end