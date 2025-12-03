class HarvestsController < ApplicationController
  before_action :set_harvest, only: %i[ show edit update destroy ]
  skip_before_action :set_harvest, only: %i[ report report_pdf ]

  def index
    @harvests = Harvest.all

    # Search Logic
    if params[:query].present?
      # Searches by Crop Type OR Land Name (Joining the tables)
      search_term = "%#{params[:query]}%"
      @harvests = @harvests.joins(:land)
                           .where("harvests.crop_type LIKE ? OR lands.name LIKE ?", search_term, search_term)
    end

    @harvests = @harvests.order(created_at: :desc).page(params[:page]).per(10)

  end

  def show
  end

  def new
    @harvest = Harvest.new
    @lands = Land.all
    # Load all crops to populate the dropdown
    @crop_types = CropType.all
  end

  def edit
    @lands = Land.all
    @crop_types = CropType.all
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

  #Generate Report PDF
  def report_pdf
    @lands = Land.all
    @harvests = Harvest.all

    # Apply filters
    @harvests = @harvests.where(land_id: params[:land_id]) if params[:land_id].present?
    @harvests = @harvests.where("actual_date >= ?", params[:start_date]) if params[:start_date].present?
    @harvests = @harvests.where("actual_date <= ?", params[:end_date]) if params[:end_date].present?

    @total_amount = @harvests.sum(:amount)

    respond_to do |format|
      format.html  # For debugging
      format.pdf do
        render pdf: "harvest_report",
               template: "harvests/report_pdf",
               layout: "pdf"
      end
    end
  end



  private

  def set_harvest
    @harvest = Harvest.find(params[:id])
  end

  def harvest_params
    params.expect(harvest: [ :land_id, :planned_date, :actual_date, :amount, :unit, :crop_type ])
  end
end
