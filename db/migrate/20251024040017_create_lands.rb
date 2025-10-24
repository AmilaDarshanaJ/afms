class CreateLands < ActiveRecord::Migration[8.0]
  def change
    create_table :lands do |t|
      t.string :name
      t.string :crop_type
      t.string :address
      t.decimal :latitude
      t.decimal :longitude
      t.decimal :extent
      t.string :harvest_frequency
      t.string :boundary_north
      t.string :boundary_south
      t.string :boundary_east
      t.string :boundary_west
      t.string :owner_manager_name

      t.timestamps
    end
  end
end
