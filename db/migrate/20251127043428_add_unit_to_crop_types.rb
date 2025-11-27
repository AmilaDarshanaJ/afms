class AddUnitToCropTypes < ActiveRecord::Migration[8.0]
  def change
    add_column :crop_types, :unit, :string
  end
end
