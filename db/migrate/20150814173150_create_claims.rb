class CreateClaims < ActiveRecord::Migration
  def change
    create_table :claims do |t|
      t.integer :restaurant_id
      t.integer :user_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :tel
      t.string :address
      t.string :locality
      t.string :region
      t.string :zipcode

      t.timestamps null: false
    end
  end
end
