class ActivitiesController < ApplicationController
  # 1. Enable respond_to for CSV export
  include ActionController::MimeResponds
  before_action :set_activity, only: %i[ show edit update destroy ]

  # GET /activities/report
  # FIX: Updated this method to include all filtering and pagination logic
  def report
    # 1. BASE SCOPE (Used for Metrics Cards)
    # This list includes EVERYTHING matching the Date/Search, IGNORING the Status filter.
    base_scope = Activity.includes(:land).order(start_date: :desc)

    # Apply Search
    if params[:q].present?
      keyword = "%#{params[:q].downcase}%"
      base_scope = base_scope.joins(:land).where(
        "LOWER(lands.name) LIKE ? OR LOWER(activities.summary) LIKE ? OR LOWER(activities.status) LIKE ?",
        keyword, keyword, keyword
      )
    end

    # Apply Date Range
    base_scope = base_scope.where('start_date >= ?', params[:date_start]) if params[:date_start].present?
    base_scope = base_scope.where('start_date <= ?', params[:date_end]) if params[:date_end].present?

    # Assign to variable for the View
    @metrics_activities = base_scope

    # 2. TABLE SCOPE (Used for the Data Table)
    # Start with the base list, then filter down by Status
    table_scope = base_scope

    if params[:status].present? && params[:status] != 'all'
      # ROBUST FILTER: Checks for "in_progress" AND "In Progress" to ensure matches
      status_term = params[:status].to_s.downcase
      table_scope = table_scope.where(
        "LOWER(status) = ? OR LOWER(status) = ?",
        status_term,
        status_term.gsub('_', ' ') # Checks "in progress" vs "in_progress"
      )
    end

    # Paginate the table data
    @activities = table_scope.page(params[:page]).per(10)

    respond_to do |format|
      format.html
      format.csv { send_data table_scope.to_csv, filename: "activities-report-#{Date.today}.csv" }
    end
  end

  # GET /activities or /activities.json
  def index
    # 1. Base Scope
    scope = Activity.includes(:land).order(start_date: :desc)

    # 2. Filter by Search (Keyword)
    if params[:q].present?
      keyword = "%#{params[:q].downcase}%"
      scope = scope.joins(:land).where(
        "LOWER(lands.name) LIKE ? OR LOWER(activities.summary) LIKE ? OR LOWER(activities.status) LIKE ?",
        keyword, keyword, keyword
      )
    end

    # 3. Filter by Status
    if params[:status].present? && params[:status] != 'all'
      scope = scope.where(status: params[:status])
    end

    # 4. Filter by Date Range
    scope = scope.where('start_date >= ?', params[:date_start]) if params[:date_start].present?
    scope = scope.where('start_date <= ?', params[:date_end]) if params[:date_end].present?

    # 5. DATA FOR METRICS (All matching records, NOT paginated)
    @metrics_activities = scope

    # 6. DATA FOR TABLE (Paginated - 10 per page)
    @activities = scope.page(params[:page]).per(10)

    respond_to do |format|
      format.html
      # Fix: Pass current params to CSV so filters apply to the download too
      format.csv { send_data scope.to_csv, filename: "activities-report-#{Date.today}.csv" }
    end
  end

  # GET /activities/1 or /activities/1.json
  def show
  end

  # GET /activities/new
  def new
    @activity = Activity.new
    @lands = Land.all
  end

  # GET /activities/1/edit
  def edit
    @lands = Land.all
  end

  # POST /activities or /activities.json
  def create
    @activity = Activity.new(activity_params)

    respond_to do |format|
      if @activity.save
        format.html { redirect_to @activity, notice: "Activity was successfully created." }
        format.json { render :show, status: :created, location: @activity }
      else
        @lands = Land.all # Reload lands if validation fails
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activities/1 or /activities/1.json
  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to @activity, notice: "Activity was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @activity }
      else
        @lands = Land.all # Reload lands if validation fails
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1 or /activities/1.json
  def destroy
    @activity.destroy!

    respond_to do |format|
      format.html { redirect_to activities_path, notice: "Activity was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_activity
    @activity = Activity.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def activity_params
    params.require(:activity).permit(:land_id, :start_date, :end_date, :summary, :status)
  end
end