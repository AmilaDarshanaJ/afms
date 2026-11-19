class DailyPickingsController < ApplicationController
  before_action :set_picking, only: %i[edit update destroy]
  before_action :load_form_data, only: %i[new create edit update]

  def index
    @lands = Land.order(:name)
    @crop_names = CropType.order(:name).pluck(:name)

    scope = filter_scope(DailyPicking.all)
    @totals_filtered = scope.group(:unit).sum(:quantity)
    @totals_today = DailyPicking.where(picked_on: Date.current).group(:crop_type, :unit).sum(:quantity)
    @totals_month = DailyPicking.where(picked_on: Date.current.all_month).group(:crop_type, :unit).sum(:quantity)

    @pickings = scope.includes(:land).order(picked_on: :desc, id: :desc).page(params[:page]).per(15)
  end

  def new
    land = Land.find_by(id: params[:land_id])
    @picking = DailyPicking.new(
      land: land,
      crop_type: land&.crop_type,
      picked_on: parse_date(params[:picked_on]) || Date.current
    )
  end

  def create
    @picking = DailyPicking.new(picking_params)
    if @picking.save
      msg = "Saved #{helpers.dp_qty(@picking.quantity)} #{@picking.unit} of #{@picking.crop_type}."
      if params[:add_another].present?
        redirect_to new_daily_picking_path(land_id: @picking.land_id, picked_on: @picking.picked_on),
                    notice: "#{msg} Add the next one."
      else
        redirect_to daily_pickings_path, notice: msg
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @picking.update(picking_params)
      redirect_to daily_pickings_path, notice: "Picking updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @picking.destroy
    redirect_to daily_pickings_path, notice: "Picking deleted.", status: :see_other
  end

  private

  def set_picking
    @picking = DailyPicking.find(params[:id])
  end

  def load_form_data
    @lands = Land.order(:name)
    @crop_types = CropType.order(:name)
    @recent = DailyPicking.includes(:land).order(created_at: :desc).limit(5)
  end

  def picking_params
    params.require(:daily_picking).permit(:land_id, :crop_type, :picked_on, :quantity, :workers_count, :notes)
  end

  def filter_scope(scope)
    scope = scope.where(land_id: params[:land_id]) if params[:land_id].present?
    scope = scope.where(crop_type: params[:crop_type]) if params[:crop_type].present?
    from = parse_date(params[:from])
    to   = parse_date(params[:to])
    scope = scope.where(picked_on: from..) if from
    scope = scope.where(picked_on: ..to) if to
    scope
  end

  def parse_date(value)
    Date.iso8601(value.to_s)
  rescue ArgumentError
    nil
  end
end