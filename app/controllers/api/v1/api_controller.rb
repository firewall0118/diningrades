require 'factual'
require 'httparty'

# FIXME: this is way too much logic for one controller i understand wanting to namespace everything under api/version.
# however, the website itself is really the only thing to consume its own api so it seems uncessary. The methods under
# this controller deal with a bunch of different resources and should be broken up as such. Also, much of this logic
# should be contained within models.

class Api::V1::ApiController < ActionController::Base
  include HTTParty

  respond_to :html, :json
  before_action :set_factual_api

  # FIXME: on mobile devices we should make an attempt to use the device's location using GPS instead of always geo
  # locating on the IP address.
  def get_client_address
    info = get_address_info(request.remote_ip)
    render json: { 
      :success => true,
      :info => info
    }
  end

  def search_test
    category_ids = [312, 347] # bar & restaurants

    # --- call factual api ---
    table = @factual.table("places-us")
    if params[:meters].present?
      meters = params[:meters].to_i
      if meters > 25000
        meters = 25000
      end
      table = table.geo("$circle" => {"$center" => [params[:lat], params[:lon]], "$meters" => meters})
    end

    adrs = params[:address]

    # filter type of cuisine
    if params[:cuisine].present?
      category_ids = [ params[:cuisine].to_i ]
    end

    # search for city, state or zip
    if adrs.present?
      restaurants = table.filters("$and" => [ {"category_ids" => {"$includes_any" => category_ids}}, {"$or" => [ {"locality" => {"$search" => adrs}}, {"region" => {"$eq" => adrs}}, {"postcode" => {"$eq" => adrs}} ]} ])
    else
      restaurants = table.filters("category_ids" => {"$includes_any" => category_ids})
    end

    # offset for show more
    offset = 0
    if params[:offset].present?
      offset = params[:offset].to_i
    end

    rows_per_page = 100
    restaurants = restaurants.offset(offset).rows

    factual_ids = restaurants.map { |a| a["factual_id"] }
    grades = Restaurant.where(factual_id: factual_ids)

    restaurants.map! { |r| \
      c = grades.select { |g| g.factual_id == r["factual_id"] }
      if c.present?
        r["grades"] = c[0].grades
        r["satisfaction"] = c[0].satisfaction
        r["recommendation"] = c[0].recommendation
        r["user_restaurants"] = c[0].user_restaurants
      else
        r["grades"] = 0
        r["satisfaction"] = 0
        r["recommendation"] = 0
        r["user_restaurants"] = []
      end
      r
    }

    render json: { 
      :success => true,
      :restaurants => restaurants
    }
  end
  
  def search
    # FIXME: this is a mess. Firstly, it makes a copy of information in factual. I specifically requested we only store
    # rating averages and the factual ID. One thing that makes this difficult allowing users to filter by grade which is
    # not stored on factual. All searches for restaurants should simply be done using a factual query, then grade information
    # should be queried and added to the results. To solve the grade problem, we can firstly query the local restaurant db for
    # factual ids that contain a grade, then add a filter for factual id using $in with the results of that grade based query.
    # With this approach, i would recommend adding lat/lng fields to the local restaurant db so that the grade searches can be
    # localized. Once a factual search has been completed, then query the local db for the returned factual IDs. here is some pseudo-code
    #
    # restaurants = Factual.query
    # factual_ids = restaurants.map {|r| r['factual_id']}
    # grades = Restaurant.where(factual_id: factual_ids)
    # restaurants.map { |r| r[grade] = grades.find_by_factual; r }

    category_ids = [312, 347] # bar & restaurants

    # --- call factual api ---
    table = @factual.table("places-us")
    if params[:meters].present?
      meters = params[:meters].to_i
      if meters > 25000
        meters = 25000
      end
      table = table.geo("$circle" => {"$center" => [params[:lat], params[:lon]], "$meters" => meters})
    end

    adrs = params[:address]

    # filter type of cuisine
    if params[:cuisine].present?
      category_ids = [ params[:cuisine].to_i ]
    end

    # search for city, state or zip
    if adrs.present?
      restaurants = table.filters("$and" => [ {"category_ids" => {"$includes_any" => category_ids}}, {"$or" => [ {"locality" => {"$search" => adrs}}, {"region" => {"$eq" => adrs}}, {"postcode" => {"$eq" => adrs}} ]} ])
    else
      restaurants = table.filters("category_ids" => {"$includes_any" => category_ids})
    end

    # offset for show more
    offset = 0
    if params[:offset].present?
      offset = params[:offset].to_i
    end

    rows_per_page = 100
    restaurants = restaurants.offset(offset).rows
    #restaurants = restaurants.page(offset / rows_per_page + 1, :per => rows_per_page)

    factual_ids = restaurants.map { |a| a["factual_id"] }
    
    # keep restaurant in local database
    restaurants.each do |r|
      cuisine = category_links.select { |c| r["category_ids"].include? c[:value].to_i }
      
      new_restaurant = false
      rs = Restaurant.where(factual_id: r["factual_id"]).first_or_create do |nr|
        nr.category_ids = cuisine.map {|x| "'#{x[:value]}'"} * ', '
        nr.cuisine = cuisine.map {|x| x[:label]} * ', '
        nr.name = r["name"]
        nr.country = r["country"]
        nr.region = r["region"]
        nr.locality = r["locality"]
        nr.address = r["address"]
        nr.address_extended = r["address_extended"]?r["address_extended"]:''
        nr.website = r["website"]
        nr.email = r["email"]
        nr.tel = r["tel"]
        nr.postcode = r["postcode"]
        nr.hours_display = r["hours_display"]
        nr.latitude = r["latitude"].to_f
        nr.longitude = r["longitude"].to_f
        new_restaurant = true
      end

      # FIXME: This is not the correct importation functionality. Why a separate table? A Rating, not a DgRating, should be created
      # for each entry of an imported spreadsheet at import.

      if new_restaurant
        # search ratings that are imported already
        if rs.tel
          tel = rs.tel.gsub /[()\-\s+]/, ''
        else
          tel = ''
        end

        dg_ratings = DgRating.where("(telephone <> '' AND telephone = ?) OR (lat = ? AND lon = ?) OR (restaurant_name = ? AND city = ? AND state = ?)", 
                                  tel, 
                                  rs.latitude, 
                                  rs.longitude,
                                  rs.name,
                                  rs.locality,
                                  rs.region)
        if dg_ratings.present?
          total_s = dg_ratings.sum(:satisfaction_rating)
          total_r = dg_ratings.sum(:recommendation_rating)
          total_cnt = dg_ratings.count

          # FIXME: these calculations should be perfomed in a model hook when a rating is created. idealy the re-calculation of
          # averages would be in a restaurant method that gets called from a rating after_save hook.
          rs.update_attributes(total_satisfaction: total_s,
                                      total_recommendation: total_r,
                                      rating_count: total_cnt,
                                      satisfaction: total_s / total_cnt.to_d,
                                      recommendation: total_r / total_cnt.to_d)
        end
      end
    end

    #restaurants = Restaurant.active.where(:factual_id => factual_ids)

    # --- search in the local restaurant database ---

    # FIXME: search for restaurants should be completely done within factual
    restaurants = Restaurant.active

    if params[:meters].present?
      meters = params[:meters].to_i
      #restaurants = restaurants.within(meters / 1000, :origin => [params[:lat], params[:lon]])
      original = [params[:lat], params[:lon]]
      south_west_point = [params[:south_west_point_lat], params[:south_west_point_lon]]
      north_east_point = [params[:north_east_point_lat], params[:north_east_point_lon]]
      restaurants = restaurants.in_bounds([south_west_point, north_east_point], :origin => original, :order=>'distance')
    end

    if params[:grade].present?
      range = params[:grade].split(',')
      restaurants = Restaurant.active.where(:grades => range[0].to_f..range[1].to_f)
    end

    if params[:cuisine].present?
      restaurants = restaurants.where('category_ids LIKE ?', "%'" + params[:cuisine] + "'%")
    end

    if params[:address].present?
      #restaurants = restaurants.where('concat(region::text, locality::text, address::text, address_extended::text, postcode::text) LIKE ?', '%' + params[:address] + '%')
      restaurants = restaurants.where('concat(region::text, locality::text, postcode::text) ILIKE ?', '%' + params[:address] + '%')
    end

    restaurants = restaurants.limit(rows_per_page).offset(offset)
    #restaurants = restaurants.order(name: :asc)

    render json: { 
      :success => true,
      #:restaurants => restaurants.to_json(:include => {ratings: {include: :user}})
      :restaurants => restaurants.to_json(:include => [ :user_restaurants, {ratings: {include: :user}} ] )
    }
  end

  def questions
    questions = Question.all.order(extended: :asc, position: :asc)
    render json: {
      :success => true,
      :questions => questions.to_json(include: :options)
    }
  end

  def restaurant
    restaurant = Restaurant.where(factual_id: params[:factual_id]).first
    render json: {
      :success => true,
      :restaurant => restaurant.to_json(:include => {ratings: {include: :user}})
    }
  end

  def myratings
    if current_user
      ratings = current_user.ratings
      render json: {
        :success => true,
        :ratings => ratings.to_json(include: :restaurant)
      }
    else
      render json: {
        :success => false
      }
    end
  end

  def myrestaurants
    if current_user
      restaurants = current_user.user_restaurants
      render json: {
        :success => true,
        :myrestaurants => restaurants.to_json(include: :restaurant)
      }
    else
      render json: {
        :success => false
      }
    end
  end

  def restaurant_ratings
    r = Restaurant.find(params[:id])
    if r
      ratings = r.ratings
      render json: {
        :success => true,
        :ratings => ratings.to_json(include: :user)
      }
    else
      render json: {
        :success => false
      }
    end
  end

  # FIXME: we will not be adding any data to factual, so lets ensure there is nothing in the frontend about submitting a restaurant

  def suggest_restaurant
    cuisine = params[:cuisine]
    if cuisine.blank?
      cuisine = []
    end

    restaurant = Restaurant.where(factual_id: "SR-#{Restaurant.last.id+1}",
                                  category_ids: cuisine.map {|x| "'#{x[:value]}'"} * ', ',
                                  cuisine: cuisine.map {|x| x[:label]} * ', ',
                                  name: params["name"],
                                  country: params["country"],
                                  region: params["region"],
                                  locality: params["locality"],
                                  address: params["address"],
                                  address_extended: params["address_extended"],
                                  website: params["website"],
                                  email: params["email"],
                                  tel: params["tel"],
                                  postcode: params["postcode"],
                                  hours_display: params["hours_display"],
                                  latitude: params["latitude"].to_f,
                                  longitude: params["longitude"].to_f,
                                  active: false).first_or_create

    render json: {
      :success => true
    }
  end

  # FIXME: we will not be updating any restaurants in factual, so lets make sure there is nothing in the frontend about this
  def update_restaurant
    cuisine = params[:cuisine]
    restaurant = Restaurant.find_by factual_id: params[:factual_id]

    restaurant = restaurant.update_attributes(
                                  category_ids: cuisine.map {|x| "'#{x[:value]}'"} * ', ',
                                  cuisine: cuisine.map {|x| x[:label]} * ', ',
                                  name: params["name"],
                                  country: params["country"],
                                  region: params["region"],
                                  locality: params["locality"],
                                  address: params["address"],
                                  address_extended: params["address_extended"],
                                  website: params["website"],
                                  email: params["email"],
                                  tel: params["tel"],
                                  postcode: params["postcode"],
                                  hours_display: params["hours_display"],
                                  latitude: params["latitude"].to_f,
                                  longitude: params["longitude"].to_f)

    render json: {
      :restaurant => Restaurant.find_by(factual_id: params[:factual_id]),
      :success => true
    }
  end

  def claim_restaurant
    claim = Claim.where(restaurant_id: params[:restaurant_id],
                        user_id: current_user,
                        first_name: params[:first_name],
                        last_name: params[:last_name],
                        email: params[:email],
                        tel: params[:tel],
                        address: params[:address],
                        locality: params[:locality],
                        region: params[:region],
                        zipcode: params[:zipcode]).first_or_create

    UserMailer.claim_restaurant(claim).deliver

    render json: {
      :success => true
    }
  end

  def submit_rating
    # FIXME: nothing in here really stops a rating from being added without a user being logged in. this will be a serious
    # problem if a bot finds the endpoint
    restaurant = Restaurant.where(factual_id: params[:factual_id]).first

    grades = 100 # default grades to calculate
    satisfaction = params[:satisfaction].to_i
    recommendation = params[:recommendation].to_i
    # vote satisfaction
    restaurant.vote_by :voter => current_user, :vote_scope => 'satisfaction', :vote_weight => satisfaction

    # vote recommendation
    restaurant.vote_by :voter => current_user, :vote_scope => 'recommendation', :vote_weight => recommendation

    # add user rating
    # FIXME: the usage of the voting gem seems uncessary. each rating should simply store the grade, satisfaction score,
    # and the recommendation score. after it is saved, it should trigger the restaurant to update its average grade, average
    # satisfaction score, and average recommendation.
    user_rating = Rating.new do |u|
      u.user = current_user
      u.restaurant = restaurant
      u.satisfaction = satisfaction
      u.recommendation = recommendation
      u.comment = params[:comment]
    end
    user_rating.save

    # add questions
    questions = Question.all
    questions.each do |f|
      # FIXME: relying on paramter names is flimsy. it is a better practice to use arrays in the post string.
      # taking the array approach would also allow you to use nested attributes
      id = params["question" + f.id.to_s].to_i
      if id > 0
        option = Option.find(id)

        answer = Answer.new do |a|
          a.rating = user_rating
          a.option = option
        end
        answer.save

        grades = grades - option.deduction
      end
    end
    # minus satisfaction and recommendataion
    # FIXME: what is this? the satisfaction and recommendation grade should have no affect on the clenliness score
    grades = grades - (10 - satisfaction - recommendation) * 10
    grades = 0 if grades < 0

    # add grades to vote
    # FIXME: all we need to store with each rating are the three scores, and then have the restaurant store an average,
    # what is this for?
    restaurant.vote_by :voter => current_user, :vote_scope => 'grades', :vote_weight => grades

    # update restaurant rating totals
    size = restaurant.find_votes_for(:vote_scope => 'satisfaction').size.to_f
    #satisfaction = restaurant.find_votes_for(:vote_scope => 'satisfaction').sum(:vote_weight) / size
    #recommendation = restaurant.find_votes_for(:vote_scope => 'recommendation').sum(:vote_weight) / size
    restaurant_grades = restaurant.find_votes_for(:vote_scope => 'grades').sum(:vote_weight) / size

    cnt = restaurant.rating_count + 1
    total_s = restaurant.total_satisfaction + satisfaction
    total_r = restaurant.total_recommendation + recommendation

    # FIXME all this averaging logic should be done in the restaurant's model
    restaurant.update_attributes(satisfaction: total_s / cnt.to_d, 
                              recommendation: total_r / cnt.to_d, 
                              total_satisfaction: total_s,
                              total_recommendation: total_r,
                              rating_count: cnt,
                              grades: restaurant_grades)

    render json: {
      :grades => grades,
      :success => true
    }
  end

  def submit_food_poisoning_report
    food_report = FoodReport.new do |u|
      u.restaurant_id = params[:restaurant_id]
      u.comment = params[:comment]
      u.fever = params[:fever]
      u.nausea = params[:nausea]
      u.vomiting = params[:vomiting]
      u.diarrhea = params[:diarrhea]
      u.abdominal_pain = params[:abdominal_pain]
      u.headache = params[:headache]
      u.chest_pain = params[:chest_pain]
      u.numbness_tingling = params[:numbness_tingling]
      u.dizziness = params[:dizziness]
      u.rash = params[:rash]
      u.date_of_exposure = params[:date_of_exposure]
      u.suspected_food_time = params[:suspected_food_time]
      u.healthcare_provider = params[:healthcare_provider]
      u.provider_email = params[:provider_email]
      u.patient_name = params[:patient_name]
      u.patient_telephone = params[:patient_telephone]
      u.patient_antibiotic = params[:patient_antibiotic]
      u.facility_name = params[:facility_name]
      u.facility_phone = params[:facility_phone]
      u.send_to_restaurant = params[:send_to_restaurant]
    end
    food_report.save

    render json: {
      :success => true
    }
  end

  def cuisines
    cuisines = category_links

    render json: {
      :success => true,
      :cuisines => cuisines
    }
  end

  private
  def set_factual_api
    key = "DUFvYtzc3LY2KMIo0AjOfyM7u1599Tg8ashbm2bi"
    secret = "Tf7aZgZa4PFy8HsHnLtEumJ7px6QP4xIbUrmpZu5"
    @factual = Factual.new(key, secret)
  end

  def category_links
    categories = [
      { :label => 'American', :value => '348' },
      { :label => 'Barbecue', :value => '349' },
      { :label => 'Buffets', :value => '350' },
      { :label => 'Burgers', :value => '351' },
      { :label => 'Chinese', :value => '352' },
      { :label => 'Delis', :value => '353' },
      { :label => 'Diners', :value => '354' },
      { :label => 'Fast Food', :value => '355' },
      { :label => 'French', :value => '356' },
      { :label => 'Indian', :value => '357' },
      { :label => 'Italian', :value => '358' },
      { :label => 'Japanese', :value => '359' },
      { :label => 'Korean', :value => '360' },
      { :label => 'Mexican', :value => '361' },
      { :label => 'Middle Eastern', :value => '362' },
      { :label => 'Pizza', :value => '363' },
      { :label => 'Seafood', :value => '364' },
      { :label => 'Steakhouses', :value => '365' },
      { :label => 'Sushi', :value => '366' },
      { :label => 'Thai', :value => '367' },
      { :label => 'Vegan and Vegetarian', :value => '368' },
      { :label => 'Asian', :value => '457' },
      { :label => 'Food Trucks', :value => '458' },
      { :label => 'International', :value => '464' }
    ]

    categories
  end

  def get_address_info(ip_address)
    if ip_address == "127.0.0.1"
      response = HTTParty.get "http://ip-api.com/json"
    else
      response = HTTParty.get "http://ip-api.com/json/" + ip_address
    end
  end

end
