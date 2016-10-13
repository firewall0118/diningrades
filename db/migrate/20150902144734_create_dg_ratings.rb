class CreateDgRatings < ActiveRecord::Migration
  def change
    create_table :dg_ratings do |t|
      t.decimal :bill
      t.date :dateOfDine
      t.string :comments
      t.string :response
      t.inet :ip_addr
      t.string :source
      t.timestamp :timestamp
      t.decimal :cleanliness_rating
      t.decimal :satisfaction_rating
      t.decimal :recommendation_rating
      t.string :restaurant_name
      t.string :email
      t.string :store_number
      t.string :telephone
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.decimal :lat, :precision => 6, :scale => 6
      t.decimal :lon, :precision => 6, :scale => 6

      t.timestamps null: false
    end
  end
end