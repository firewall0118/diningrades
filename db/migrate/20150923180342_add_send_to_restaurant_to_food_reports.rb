class AddSendToRestaurantToFoodReports < ActiveRecord::Migration
  def change
    add_column :food_reports, :send_to_restaurant, :boolean, :default => false
  end
end
