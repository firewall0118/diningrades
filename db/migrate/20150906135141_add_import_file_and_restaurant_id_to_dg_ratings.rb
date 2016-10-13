class AddImportFileAndRestaurantIdToDgRatings < ActiveRecord::Migration
  def change
    add_column :dg_ratings, :dg_import_id, :integer
    add_column :dg_ratings, :restaurant_id, :integer
  end
end
