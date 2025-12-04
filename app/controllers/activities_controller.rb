require 'csv'

class ActivitiesController < ApplicationController
  before_action :set_activity, only: %i[ show edit update destroy ]

  # GET /activities
  def index
    # 1. Apply Filters
    @base_scope = filter_scope(Activity.includes(:land).order(start_date: :desc))

    # 2. Metrics & Table
    @metrics_activities = @base_scope
    @activities = @base_scope.page(params[:page]).per(10)

    # 3. Export
    respond_to do |format|
      format.html
      format.csv { send_data generate_csv(@base_scope), filename: "activities-#{Date.today}.csv" }
    end
  end

  # GET /activities/report
  def report
    # 1. Apply Filters
    scope = filter_scope(Activity.includes(:land).order(start_date: :desc))

    # 2. Metrics (Unpaginated totals)
    @metrics_activities = scope

    # 3. ANALYSIS: Charts Data
    # Group by status. We use 'count' directly on the scope.
    @data_by_status = scope.group(:status).count.transform_keys { |k| k.to_s.humanize }

    # Group by Land Name
    @data_by_land = scope.joins(:land).group('lands.name').count

    # 4. Table Data (Paginated)
    @activities = scope.page(params[:page]).per(10)

    # 5. Export
    respond_to do |format|
      format.html
      format.csv { send_data generate_csv(scope), filename: "activity-report-#{Date.today}.csv" }
    end
  end

  # --- Standard Actions ---
  def new
    @activity = Activity.new
    @lands = Land.all
  end

  def edit
    @lands = Land.all
  end

  def create
    @activity = Activity.new(activity_params)
    if @activity.save
      redirect_to activities_path, notice: "✅ Activity created successfully."
    else
      @lands = Land.all
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @activity.update(activity_params)
      redirect_to activities_path, notice: "✅ Activity updated successfully."
    else
      @lands = Land.all
      render :edit, status: :unprocessable_entity
    end
  end

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

  # --- FIXED FILTERING LOGIC (SQLite Compatible) ---
  def filter_scope(scope)
    # 1. Keyword Search
    # Changed from ILIKE to LIKE for SQLite compatibility
    if params[:q].present?
      keyword = "%#{params[:q].downcase}%"
      scope = scope.joins(:land).where(
        "LOWER(lands.name) LIKE :key OR LOWER(activities.summary) LIKE :key",
        key: keyword
      )
    end

    # 2. Date Range
    scope = scope.where('start_date >= ?', params[:date_start]) if params[:date_start].present?
    scope = scope.where('start_date <= ?', params[:date_end]) if params[:date_end].present?

    # 3. Status Filter
    # Changed from ILIKE to standard SQL LOWER() comparison
    if params[:status].present? && params[:status] != 'all'
      status_term = params[:status].to_s.gsub('_', ' ').downcase
      scope = scope.where("LOWER(status) = ?", status_term)
    end

    scope
  end

  def generate_csv(records)
    CSV.generate(headers: true) do |csv|
      csv << ["Land", "Start Date", "End Date", "Summary", "Status"]
      records.each do |a|
        csv << [
          a.land&.name || "Unassigned",
          a.start_date,
          a.end_date,
          a.summary,
          a.status.to_s.humanize
        ]
      end
    end
  end
end