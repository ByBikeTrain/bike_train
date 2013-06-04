class Address < ActiveRecord::Base
  attr_accessible :city, :country, :line_address, :phone, :state, :zip, :lat, :lng
end
