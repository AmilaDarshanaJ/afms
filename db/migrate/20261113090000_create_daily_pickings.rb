class CreateDailyPickings < ActiveRecord::Migration[8.0]
  def change
    create_table :daily_pickings do |t|
      t.references :land, null: false, foreign_key: true
      t.string  :crop_type, null: false
      t.date    :picked_on, null: false
      t.decimal :quantity, precision: 12, scale: 2, null: false
      t.string  :unit
      t.integer :workers_count
      t.text    :notes
      t.timestamps
    end
    add_index :daily_pickings, :picked_on
    add_index :daily_pickings, [:land_id, :picked_on]
  end
end