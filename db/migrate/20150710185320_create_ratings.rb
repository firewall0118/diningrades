class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.belongs_to :user
      t.belongs_to :restaurant

      t.decimal :satisfaction
      t.decimal :recommendation
      t.text :comment

      t.timestamps null: false
    end
  end
end
