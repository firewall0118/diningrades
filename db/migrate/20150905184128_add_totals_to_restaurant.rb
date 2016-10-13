class AddTotalsToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :total_satisfaction, :decimal, :default => 0
    add_column :restaurants, :total_recommendation, :decimal, :default => 0
    add_column :restaurants, :rating_count, :integer, :default => 0
  end
end
