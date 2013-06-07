class AddAddressesToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :origin_address_line, :text
    add_column :groups, :destination_address_line, :text
    add_column :groups, :origin_address_lat, :float
    add_column :groups, :origin_address_lng, :float
    add_column :groups, :destination_address_lat, :float
    add_column :groups, :destination_address_lng, :float
  end
end
