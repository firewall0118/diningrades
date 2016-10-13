class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.belongs_to :rating, index: true, foreign_key: true
      t.belongs_to :option, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
