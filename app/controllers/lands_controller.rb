class LandsController < ApplicationController
  before_action :set_land, only: %i[ show edit update destroy ]

  # GET /lands
  def index
    @lands = Land.all.order(created_at: :desc) # Orders newest lands first
  end

  # GET /lands/1
  def show
  end

  # GET /lands/new
  def new
    @land = Land.new
  end

  # GET /lands/1/edit
  def edit
  end

  # POST /lands
  def create
    @land = Land.new(land_params)

    if @land.save
      # Redirect to the list (Dashboard) instead of the show page
      redirect_to lands_path, notice: "✅ New land created successfully."
    else
      # 'status: :unprocessable_entity' is REQUIRED for the form to show errors
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /lands/1
  def update
    if @land.update(land_params)
      # Redirect to the list (Dashboard)
      redirect_to lands_path, notice: "✅ Land details updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /lands/1
  # DELETE /lands/1
  def destroy
    @land = Land.find(params[:id])

    # Check if ANY child records exist (Harvests OR Activities)
    if @land.harvests.exists? || @land.activities.exists?
      redirect_to lands_path, alert: "⚠️ Cannot delete Land! It has related Harvests or Activities. Please delete them first."
    else
      @land.destroy
      redirect_to lands_path, notice: "🗑️ Land deleted successfully."
    end
  end

  private

  # Use callbacks to share common setup
  def set_land
    @land = Land.find(params[:id])
  end

  # Strong Parameters (Standard Rails Pattern)
  def land_params
    params.require(:land).permit(
      :name,
      :crop_type,
      :address,
      :latitude,
      :longitude,
      :extent,
      :boundary_north,
      :boundary_south,
      :boundary_east,
      :boundary_west,
      :owner_manager_name
    )
  end
end