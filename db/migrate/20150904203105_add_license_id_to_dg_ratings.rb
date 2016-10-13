class AddLicenseIdToDgRatings < ActiveRecord::Migration
  def change
    add_column :dg_ratings, :license_id, :string
  end
end
