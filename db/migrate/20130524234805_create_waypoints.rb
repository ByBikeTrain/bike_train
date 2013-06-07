class CreateWaypoints < ActiveRecord::Migration
  def change
    create_table :waypoints do |t|
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end
end
