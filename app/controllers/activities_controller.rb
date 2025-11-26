class ActivitiesController < ApplicationController
  # 1. FIX: Enable respond_to for CSV export
  include ActionController::MimeResponds

  before_action :set_activity, only: %i[ show edit update destroy ]

  # GET /activities/report
  def report
    @activities = Activity.includes(:land).order(start_date: :desc)
    @activities_by_status = @activities.group_by(&:status)
  end

  # GET /activities or /activities.json
  def index
    # Start with all activities, ordered by date
    @activities = Activity.includes(:land).order(start_date: :desc)

    # Search logic
    if params[:q].present?
      keyword = "%#{params[:q].downcase}%"

      @activities = @activities.joins(:land).where(
        "LOWER(lands.name) LIKE ? OR LOWER(activities.summary) LIKE ? OR LOWER(activities.status) LIKE ?",
        keyword, keyword, keyword
      )
    end

    # 2. FIX: Handle the CSV Export
    respond_to do |format|
      format.html # Renders index.html.erb
      format.json # Renders index.json.jbuilder
      format.csv { send_data @activities.to_csv, filename: "activities-report-#{Date.today}.csv" }
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