class CreateFinancialRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :financial_records do |t|
      t.references :land, null: false, foreign_key: true
      t.string :category
      t.decimal :amount, precision: 10, scale: 2
      t.date :transaction_date
      t.text :description
      t.integer :transaction_type

      t.timestamps
    end
  end
end
