class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :factual_id
      t.string :category_ids
      t.string :cuisine
      t.string :name
      t.string :country
      t.string :region
      t.string :locality
      t.string :address
      t.string :address_extended
      t.string :website
      t.string :email
      t.string :tel
      t.string :postcode
      t.string :hours_display
      t.decimal :latitude
      t.decimal :longitude
      t.decimal :satisfaction, default: 0, null: false
      t.decimal :recommendation, default: 0, null: false
      t.decimal :grades, default: 0, null: false

      t.timestamps null: false
    end

    add_index :restaurants, :factual_id, unique: true
  end
end
