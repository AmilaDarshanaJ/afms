class ActivitiesController < ApplicationController
  before_action :set_activity, only: %i[ show edit update destroy ]

  # GET /activities
  def index
    # 1. Apply Base Filters (Search & Date)
    @base_scope = apply_filters(Activity.includes(:land).order(start_date: :desc))

    # 2. Apply Status Filter (Specific to Index if needed, or general)
    if params[:status].present? && params[:status] != 'all'
      # Handles both "In Progress" (DB) and "in_progress" (URL params)
      status_term = params[:status].to_s.downcase.gsub('_', ' ')
      @base_scope = @base_scope.where("LOWER(status) = ?", status_term)
    end

    # 3. Metrics Data (Unpaginated - for the counters at top of page)
    @metrics_activities = @base_scope

    # 4. Table Data (Paginated)
    @activities = @base_scope.page(params[:page]).per(10)

    # 5. CSV Export
    respond_to do |format|
      format.html
      format.csv { send_data @base_scope.to_csv, filename: "activities-#{Date.today}.csv" }
    end
  end

  # GET /activities/report
  def report
    # Reuses the exact same logic as Index for consistency
    @base_scope = apply_filters(Activity.includes(:land).order(start_date: :desc))

    # Apply Status Filter
    if params[:status].present? && params[:status] != 'all'
      status_term = params[:status].to_s.downcase.gsub('_', ' ')
      @base_scope = @base_scope.where("LOWER(status) = ?", status_term)
    end

    @metrics_activities = @base_scope
    @activities = @base_scope.page(params[:page]).per(10)

    respond_to do |format|
      format.html
      format.csv { send_data @base_scope.to_csv, filename: "activity-report-#{Date.today}.csv" }
    end
  end

  # GET /activities/1
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

  # POST /activities
  def create
    @activity = Activity.new(activity_params)

    if @activity.save
      # Redirect to the main list (Index)
      redirect_to activities_path, notice: "✅ Activity created successfully."
    else
      # RELOAD LANDS so dropdown doesn't crash
      @lands = Land.all
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /activities/1
  def update
    if @activity.update(activity_params)
      # Redirect to the main list (Index)
      redirect_to activities_path, notice: "✅ Activity updated successfully."
    else
      # RELOAD LANDS
      @lands = Land.all
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /activities/1
  def destroy
    @activity.destroy
    redirect_to activities_path, notice: "🗑️ Activity deleted."
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  end

  def activity_params
    params.require(:activity).permit(:land_id, :start_date, :end_date, :summary, :status)
  end

  # Shared Filtering Logic
  def apply_filters(scope)
    # 1. Keyword Search
    if params[:q].present?
      keyword = "%#{params[:q].downcase}%"
      scope = scope.joins(:land).where(
        "LOWER(lands.name) LIKE :key OR LOWER(activities.summary) LIKE :key OR LOWER(activities.status) LIKE :key",
        key: keyword
      )
    end

    # 2. Date Range
    scope = scope.where('start_date >= ?', params[:date_start]) if params[:date_start].present?
    scope = scope.where('start_date <= ?', params[:date_end]) if params[:date_end].present?

    scope
  end
end