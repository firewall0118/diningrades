class Restaurant < ActiveRecord::Base
  acts_as_votable
  acts_as_mappable :default_units => :kms,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  validates :name, presence: true

  has_many :user_restaurants
  has_many :ratings

  scope :ordered, -> { order 'updated_at DESC' }
  scope :ordered_name, -> { order 'name ASC' }
  scope :active, -> { where('active = true') }

  def self.find_by_factual(factual_id)
    r = Restaurant.where(factual_id: factual_id).first
    r.present? ? r.grades : 0
  end
end