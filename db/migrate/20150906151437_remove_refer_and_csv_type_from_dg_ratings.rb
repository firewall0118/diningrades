class RemoveReferAndCsvTypeFromDgRatings < ActiveRecord::Migration
  def change
    remove_column :dg_ratings, :refer
    remove_column :dg_ratings, :csv_type
  end
end
