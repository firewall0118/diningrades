class AddDgRatingsToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :dg_cleanliness_rating, :decimal, :default => 0
    add_column :restaurants, :dg_satisfaction_rating, :decimal, :default => 0
    add_column :restaurants, :dg_recommendation_rating, :decimal, :default => 0
  end
end
