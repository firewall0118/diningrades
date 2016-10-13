class CreateDgImports < ActiveRecord::Migration
  def change
    create_table :dg_imports do |t|
      t.string :file_name
      t.string :import_type
      t.integer :total, default: 0
      t.integer :insert_cnt, default: 0
      t.integer :update_cnt, default: 0
      t.integer :error_cnt, default: 0

      t.timestamps null: false
    end
  end
end
