class CreateActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :activities do |t|
      t.string :land
      t.date :start_date
      t.date :end_date
      t.text :summary
      t.string :status

      t.timestamps
    end
  end
end
