class Waypoint < ActiveRecord::Base
  has_many :waypoints_routes
  has_many :routes, :through => :waypoints_routes

  attr_accessible :lat, :lng

end
