class AddActiveToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :active, :boolean, :default => true
  end
end
