class AddActiveToClaim < ActiveRecord::Migration
  def change
    add_column :claims, :active, :boolean, :default => true
  end
end
