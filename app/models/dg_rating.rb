class DgRating < ActiveRecord::Base
  after_create :update_restaurant_rating
  after_destroy :destroy_restaurant_rating

  def update_restaurant_rating
    puts restaurant_name
    #tel = telephone.gsub /[()\-\s+]/, ''
    tel = ''
    
    if telephone.present? and telephone.length > 9
      tel = telephone.insert(0, '(').insert(4, ') ').insert(9, '-')
    end
    restaurant = Restaurant.where("(tel <> '' AND tel = ?) OR (latitude = ? AND longitude = ?) OR (name = ? AND locality = ? AND region = ?)", 
                                  tel, 
                                  lat, 
                                  lon,
                                  restaurant_name,
                                  city,
                                  state).last
    if restaurant
      total_s = restaurant.total_satisfaction + satisfaction_rating
      total_r = restaurant.total_recommendation + recommendation_rating
      total_cnt = restaurant.rating_count + 1
      restaurant.update_attributes(total_satisfaction: total_s,
                                  total_recommendation: total_r,
                                  rating_count: total_cnt,
                                  satisfaction: total_s / total_cnt.to_d,
                                  recommendation: total_r / total_cnt.to_d)

      update_attribute(:restaurant_id, restaurant.id)
    end
  end

  def destroy_restaurant_rating
    if restaurant_id.present?
      restaurant = Restaurant.find(restaurant_id)

      total_s = restaurant.total_satisfaction - satisfaction_rating
      total_r = restaurant.total_recommendation - recommendation_rating
      total_cnt = restaurant.rating_count - 1
      if total_cnt > 0
        restaurant.update_attributes(total_satisfaction: total_s,
                                    total_recommendation: total_r,
                                    rating_count: total_cnt,
                                    satisfaction: total_s / total_cnt.to_d,
                                    recommendation: total_r / total_cnt.to_d)
      else
        restaurant.update_attributes(total_satisfaction: 0,
                                    total_recommendation: 0,
                                    rating_count: 0,
                                    satisfaction: 0,
                                    recommendation: 0)
      end

    end
  end
end