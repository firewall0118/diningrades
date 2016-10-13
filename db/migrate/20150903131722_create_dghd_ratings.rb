class CreateDghdRatings < ActiveRecord::Migration
  def change
    create_table :dghd_ratings do |t|
      t.string :license_id
      t.string :title
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.date :dateOfinspection
      t.decimal :cleanliness_rating
    end
  end
end