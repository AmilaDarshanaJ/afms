class AddLandRefToActivities < ActiveRecord::Migration[8.0]
  def change
    add_reference :activities, :land, null: false, foreign_key: true
  end
end
