class WaypointsRoute < ActiveRecord::Base

  attr_accessible :order
  belongs_to :waypoint
  belongs_to :route
  
end
