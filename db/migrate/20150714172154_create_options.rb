class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.belongs_to :question, index: true, foreign_key: true
      t.string :title
      t.integer :deduction
      t.integer :position

      t.timestamps null: false
    end
    add_index :options, :position
  end
end
