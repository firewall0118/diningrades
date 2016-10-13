class RemoveRatingsFromRestaurant < ActiveRecord::Migration
  def change
    remove_column :restaurants, :dg_cleanliness_rating
    remove_column :restaurants, :dg_satisfaction_rating
    remove_column :restaurants, :dg_recommendation_rating
  end
end
