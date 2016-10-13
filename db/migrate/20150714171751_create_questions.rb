class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :question
      t.boolean :extended, default: false
      t.string :category
      t.integer :position

      t.timestamps null: false
    end
    add_index :questions, :category
    add_index :questions, :position
  end
end
