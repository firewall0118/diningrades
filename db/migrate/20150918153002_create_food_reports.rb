class CreateFoodReports < ActiveRecord::Migration
  def change
    create_table :food_reports do |t|
      t.belongs_to :restaurant, index: true, foreign_key: true
      t.text :comment
      t.boolean :fever, default: false
      t.boolean :nausea, default: false
      t.boolean :vomiting, default: false
      t.boolean :diarrhea, default: false
      t.boolean :abdominal_pain, default: false
      t.boolean :headache, default: false
      t.boolean :chest_pain, default: false
      t.boolean :numbness_tingling, default: false
      t.boolean :dizziness, default: false
      t.boolean :rash, default: false
      t.date :date_of_exposure
      t.string :suspected_food_time
      t.boolean :healthcare_provider, default: false
      t.string :provider_email
      t.string :patient_name
      t.string :patient_telephone
      t.boolean :patient_antibiotic, default: false
      t.string :facility_name
      t.string :facility_phone

      t.timestamps null: false
    end
  end
end
