class CreateHarvests < ActiveRecord::Migration[8.0]
  def change
    create_table :harvests do |t|
      t.references :land, null: false, foreign_key: true
      t.date :planned_date
      t.date :actual_date
      t.decimal :amount
      t.string :unit
      t.string :crop_type

      t.timestamps
    end
  end
end
