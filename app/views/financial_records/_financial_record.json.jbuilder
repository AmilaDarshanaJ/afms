json.extract! financial_record, :id, :land_id, :category, :amount, :transaction_date, :description, :transaction_type, :created_at, :updated_at
json.url financial_record_url(financial_record, format: :json)
