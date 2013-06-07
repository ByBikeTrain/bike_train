class AddLatAndLngToAddress < ActiveRecord::Migration
  def change
      add_column :addresses, :lat, :float
      add_column :addresses, :lng, :float
  end
end
