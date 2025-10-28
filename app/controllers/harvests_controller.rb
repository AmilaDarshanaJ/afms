class HarvestsController < ApplicationController
  before_action :set_harvest, only: %i[ show edit update destroy ]

  # GET /harvests or /harvests.json
  def index
    @harvests = Harvest.all
  end

  # GET /harvests/1 or /harvests/1.json
  def show
  end

  # GET /harvests/new
  def new
    @harvest = Harvest.new
    @lands = Land.all
  end

  # GET /harvests/1/edit
  def edit
  end

  # POST /harvests or /harvests.json
  def create
    @harvest = Harvest.new(harvest_params)

    respond_to do |format|
      if @harvest.save
        format.html { redirect_to @harvest, notice: "Harvest was successfully created." }
        format.json { render :show, status: :created, location: @harvest }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @harvest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /harvests/1 or /harvests/1.json
  def update
    respond_to do |format|
      if @harvest.update(harvest_params)
        format.html { redirect_to @harvest, notice: "Harvest was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @harvest }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @harvest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /harvests/1 or /harvests/1.json
  def destroy
    @harvest.destroy!

    respond_to do |format|
      format.html { redirect_to harvests_path, notice: "Harvest was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_harvest
      @harvest = Harvest.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def harvest_params
      params.expect(harvest: [ :land_id, :planned_date, :actual_date, :amount, :unit, :crop_type ])
    end
end
