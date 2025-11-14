class HarvestsController < ApplicationController
  before_action :set_harvest, only: %i[ show edit update destroy ]

  def index
    @harvests = Harvest.all
  end

  def show
  end

  def new
    @harvest = Harvest.new
    @lands = Land.all
  end

  def edit
  end

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

  def destroy
    @harvest.destroy!

    respond_to do |format|
      format.html { redirect_to harvests_path, notice: "Harvest was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # ✅ Harvest Report Action (must be public)
  def report
    @lands = Land.all
    @harvests = Harvest.all

    if params[:land_id].present?
      @harvests = @harvests.where(land_id: params[:land_id])
    end

    if params[:start_date].present?
      @harvests = @harvests.where("actual_date >= ?", params[:start_date])
    end

    if params[:end_date].present?
      @harvests = @harvests.where("actual_date <= ?", params[:end_date])
    end

    @total_amount = @harvests.sum(:amount)
  end

  private

  def set_harvest
    @harvest = Harvest.find(params[:id])
  end

  def harvest_params
    params.expect(harvest: [ :land_id, :planned_date, :actual_date, :amount, :unit, :crop_type ])
  end
end
