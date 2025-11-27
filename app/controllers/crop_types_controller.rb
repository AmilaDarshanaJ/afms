class CropTypesController < ApplicationController
  before_action :set_crop_type, only: %i[ show edit update destroy ]

  # GET /crop_types
  def index
    @crop_types = CropType.all.order(:name)
  end

  # GET /crop_types/new
  def new
    @crop_type = CropType.new
  end

  # GET /crop_types/1/edit
  def edit
  end

  # POST /crop_types
  def create
    @crop_type = CropType.new(crop_type_params)

    if @crop_type.save
      redirect_to crop_types_path, notice: "New crop added successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /crop_types/1
  def update
    if @crop_type.update(crop_type_params)
      redirect_to crop_types_path, notice: "Crop updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /crop_types/1
  def destroy
    @crop_type.destroy
    redirect_to crop_types_path, notice: "Crop deleted successfully.", status: :see_other
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_crop_type
    @crop_type = CropType.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def crop_type_params
    params.require(:crop_type).permit(:name, :description)
  end
end