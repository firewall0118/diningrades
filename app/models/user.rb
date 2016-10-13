class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_create :set_default_role

  belongs_to :role
  has_many :ratings
  has_many :user_restaurants

  acts_as_voter

  def update_with_password(params={})
    current_password = params.delete(:current_password)

    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end 
    valid_pwd = valid_password?(current_password) 
    result = if current_password.blank? || valid_pwd
      update_attributes(params)
    else
      self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
      self.attributes = params
      false
    end 

    clean_up_passwords
    result
  end

  def admin?
    self.role.try(:name) == 'admin'
  end

  def rated_count
    rates = get_votes_by_grades
    rates.size
  end

  def average_cleanliness_rating
    rates = get_votes_by_grades
    if rates.size == 0
      0
    else
      rates.sum(:vote_weight) / rates.size
    end
  end

  private
  def set_default_role
    self.role ||= Role.find_by_name('user')
  end

  def get_votes_by_grades
    Vote.where(voter_id: self, vote_scope: 'grades')
  end
end
