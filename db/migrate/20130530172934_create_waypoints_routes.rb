class CreateWaypointsRoutes < ActiveRecord::Migration
  def self.up
    create_table :waypoints_routes do |t|
        
      t.integer :waypoint_id
      t.integer :route_id
      t.integer :order
      
    end
  end
  
  def self.down
    drop_table :waypoints_routes
  end
end
