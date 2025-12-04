class HarvestsController < ApplicationController
  before_action :set_harvest, only: %i[ show edit update destroy ]
  # Ensure we don't try to find a specific harvest ID for reports
  skip_before_action :set_harvest, only: %i[ report report_pdf ]

  # GET /harvests
  def index
    # 1. Start with all harvests
    @harvests = Harvest.all

    # 2. Search Logic
    if params[:query].present?
      search_term = "%#{params[:query]}%"
      # Using 'harvests.crop_type' to prevent SQL ambiguity errors
      @harvests = @harvests.joins(:land)
                           .where("harvests.crop_type LIKE ? OR lands.name LIKE ?", search_term, search_term)
    end

    # 3. Pagination & Order
    @harvests = @harvests.order(created_at: :desc).page(params[:page]).per(10)
  end

  # GET /harvests/1
  def show
  end

  # GET /harvests/new
  def new
    @harvest = Harvest.new
    # Load data for dropdowns
    @lands = Land.all
    @crop_types = CropType.all
  end

  # GET /harvests/1/edit
  def edit
    # Load data for dropdowns
    @lands = Land.all
    @crop_types = CropType.all
  end

  # POST /harvests
  def create
    @harvest = Harvest.new(harvest_params)

    if @harvest.save
      # Redirect to the main list (Index)
      redirect_to harvests_path, notice: "✅ Harvest recorded successfully."
    else
      # CRITICAL: Reload these collections so the form dropdowns don't crash
      @lands = Land.all
      @crop_types = CropType.all
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /harvests/1
  def update
    if @harvest.update(harvest_params)
      # Redirect to the main list (Index)
      redirect_to harvests_path, notice: "✅ Harvest updated successfully."
    else
      # CRITICAL: Reload collections for the edit form
      @lands = Land.all
      @crop_types = CropType.all
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /harvests/1
  def destroy
    @harvest.destroy
    redirect_to harvests_path, notice: "🗑️ Harvest record deleted."
  end

  # --- REPORTS SECTION ---

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

  def report_pdf
    @lands = Land.all
    @harvests = Harvest.all

    # Apply filters
    @harvests = @harvests.where(land_id: params[:land_id]) if params[:land_id].present?
    @harvests = @harvests.where("actual_date >= ?", params[:start_date]) if params[:start_date].present?
    @harvests = @harvests.where("actual_date <= ?", params[:end_date]) if params[:end_date].present?

    @total_amount = @harvests.sum(:amount)

    respond_to do |format|
      format.html # For debugging
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
    # Standard Rails 7 strong parameters
    params.require(:harvest).permit(:land_id, :planned_date, :actual_date, :amount, :unit, :crop_type)
  end
end