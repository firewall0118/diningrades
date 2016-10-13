class DropDghdRatings < ActiveRecord::Migration
  def change
    drop_table :dghd_ratings
  end
end
