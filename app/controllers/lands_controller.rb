class LandsController < ApplicationController
  before_action :set_land, only: %i[ show edit update destroy ]

  # GET /lands or /lands.json
  def index
    @lands = Land.all
  end

  # GET /lands/1 or /lands/1.json
  def show
  end

  # GET /lands/new
  def new
    @land = Land.new
  end

  # GET /lands/1/edit
  def edit
  end

  # POST /lands or /lands.json
  def create
    @land = Land.new(land_params)

    respond_to do |format|
      if @land.save
        format.html { redirect_to @land, notice: "Land was successfully created." }
        format.json { render :show, status: :created, location: @land }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @land.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lands/1 or /lands/1.json
  def update
    respond_to do |format|
      if @land.update(land_params)
        format.html { redirect_to @land, notice: "Land was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @land }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @land.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lands/1 or /lands/1.json
  def destroy
    @land = Land.find(params[:id])

    if @land.harvests.exists?  # 👈 check if there are related harvests
      redirect_to land_path(@land), alert: "⚠️ Land deletion failed. Remove related harvests first."
    else
      @land.destroy
      redirect_to lands_path, notice: "✅ Land deleted successfully."
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_land
      @land = Land.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def land_params
      params.expect(land: [ :name, :crop_type, :address, :latitude, :longitude, :extent, :harvest_frequency, :boundary_north, :boundary_south, :boundary_east, :boundary_west, :owner_manager_name ])
    end

end
