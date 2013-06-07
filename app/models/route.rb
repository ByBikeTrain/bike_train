class Route < ActiveRecord::Base
  
  has_many :waypoints_routes

  has_many :waypoints, :through => :waypoints_routes

  attr_accessible :destination_lat, :destination_lng, :origin_lat, :origin_lng, :start_time, :waypoints_routes_attributes
  accepts_nested_attributes_for :waypoints_routes
  
end
