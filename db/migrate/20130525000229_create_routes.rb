class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.string :origin_lat
      t.string :origin_lng
      t.string :destination_lat
      t.string :destination_lng
      t.datetime :start_time
      t.integer :group_id

      t.timestamps
    end
  end
end
