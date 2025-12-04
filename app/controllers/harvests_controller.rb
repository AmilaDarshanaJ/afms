require 'csv' # 1. Required for CSV export

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
    # 1. Start with generic scope
    scope = Harvest.all

    # 2. Filter by Land
    if params[:land_id].present?
      scope = scope.where(land_id: params[:land_id])
    end

    # 3. Filter by Crop Type
    if params[:crop_type].present?
      scope = scope.where(crop_type: params[:crop_type])
    end

    # 4. Filter by Date
    if params[:start_date].present?
      scope = scope.where("actual_date >= ?", params[:start_date])
    end

    if params[:end_date].present?
      scope = scope.where("actual_date <= ?", params[:end_date])
    end

    # 5. Calculate Totals (Applies to all filtered results)
    @total_amount = scope.sum(:amount)

    # --- NEW: PREPARE DATA FOR GRAPHS ---
    # These queries group the filtered data so Chart.js can read it.

    # Data for Doughnut Chart (Harvests by Crop)
    # Returns a Hash: { "Wheat" => 500, "Corn" => 300 }
    @data_by_crop = scope.group(:crop_type).sum(:amount)

    # Data for Bar Chart (Harvests by Land)
    # Returns a Hash: { "Green Farm" => 1000, "Red Farm" => 200 }
    @data_by_land = scope.joins(:land).group('lands.name').sum(:amount)
    # ------------------------------------

    # 6. Load Dropdown Data
    @lands = Land.all
    @crop_types = CropType.all

    # 7. Handle Response Formats (HTML vs CSV)
    respond_to do |format|
      format.html do
        # HTML needs pagination (15 per page)
        @harvests = scope.order(actual_date: :desc).page(params[:page]).per(15)
      end

      format.csv do
        # CSV needs ALL data (No pagination)
        send_data generate_csv(scope), filename: "harvest_report_#{Date.today}.csv"
      end
    end
  end

  def report_pdf
    @harvests = Harvest.all

    # Apply the same filters
    @harvests = @harvests.where(land_id: params[:land_id]) if params[:land_id].present?
    @harvests = @harvests.where(crop_type: params[:crop_type]) if params[:crop_type].present?
    @harvests = @harvests.where("actual_date >= ?", params[:start_date]) if params[:start_date].present?
    @harvests = @harvests.where("actual_date <= ?", params[:end_date]) if params[:end_date].present?

    @total_amount = @harvests.sum(:amount)
    @lands = Land.all

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "harvest_report",
               template: "harvests/report_pdf",
               layout: "pdf"
      end
    end
  end

  private

  # Method to generate CSV data
  def generate_csv(records)
    CSV.generate(headers: true) do |csv|
      # Define Headers
      csv << ["Date", "Land", "Crop Type", "Amount", "Unit"]

      # Add Data Rows
      records.each do |harvest|
        csv << [
          harvest.actual_date,
          harvest.land&.name, # Safe navigation in case land is missing
          harvest.crop_type,
          harvest.amount,
          harvest.unit
        ]
      end
    end
  end

  def set_harvest
    @harvest = Harvest.find(params[:id])
  end

  def harvest_params
    # Standard Rails 7 strong parameters
    params.require(:harvest).permit(:land_id, :planned_date, :actual_date, :amount, :unit, :crop_type)
  end
end