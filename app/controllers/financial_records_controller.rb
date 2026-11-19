class FinancialRecordsController < ApplicationController
  before_action :set_financial_record, only: %i[ show edit update destroy ]

  # GET /financial_records or /financial_records.json
  def index
    @financial_records = FinancialRecord.all
  end

  # GET /financial_records/1 or /financial_records/1.json
  def show
  end

  # GET /financial_records/new
  def new
    @financial_record = FinancialRecord.new
  end

  # GET /financial_records/1/edit
  def edit
  end

  # POST /financial_records or /financial_records.json
  def create
    @financial_record = FinancialRecord.new(financial_record_params)

    respond_to do |format|
      if @financial_record.save
        format.html { redirect_to @financial_record, notice: "Financial record was successfully created." }
        format.json { render :show, status: :created, location: @financial_record }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @financial_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /financial_records/1 or /financial_records/1.json
  def update
    respond_to do |format|
      if @financial_record.update(financial_record_params)
        format.html { redirect_to @financial_record, notice: "Financial record was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @financial_record }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @financial_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /financial_records/1 or /financial_records/1.json
  def destroy
    @financial_record.destroy!

    respond_to do |format|
      format.html { redirect_to financial_records_path, notice: "Financial record was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_financial_record
      @financial_record = FinancialRecord.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def financial_record_params
      params.expect(financial_record: [ :land_id, :category, :amount, :transaction_date, :description, :transaction_type ])
    end
end
