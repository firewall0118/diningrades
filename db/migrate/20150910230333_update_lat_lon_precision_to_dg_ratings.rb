class UpdateLatLonPrecisionToDgRatings < ActiveRecord::Migration
  def change
    change_column :dg_ratings, :lat, :decimal, :precision => 12, :scale => 6
    change_column :dg_ratings, :lon, :decimal, :precision => 12, :scale => 6
  end
end
