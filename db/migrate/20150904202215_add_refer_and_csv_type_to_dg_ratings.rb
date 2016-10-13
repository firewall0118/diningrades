class AddReferAndCsvTypeToDgRatings < ActiveRecord::Migration
  def change
    add_column :dg_ratings, :refer, :string
    add_column :dg_ratings, :csv_type, :string
  end
end
