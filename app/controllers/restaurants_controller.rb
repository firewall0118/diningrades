require 'csv'

class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:create]
  load_and_authorize_resource except: [:show]
  layout 'admin'
  
  # GET /restaurants
  def index
    authorize! :manage, Restaurant
    @restaurants = Restaurant.ordered_name
    @filter_active = params[:filter_active]
    if @filter_active.present?
      @restaurants = @restaurants.where(active: @filter_active)
    end
    @restaurants = @restaurants.page(params[:page])
  end

  # GET /restaurants/new
  def new
  end

  # GET /restaurants/1/edit
  def edit
  end

  # POST /restaurants
  def create
    if @restaurant.save
      redirect_to restaurants_path, notice: 'Restaurant was successfully created.'
    else
      render :new
    end
  end

  def show
    @restaurant = restaurant.find(params[:id])
  end

  # PATCH/PUT /restaurants/1
  def update
    if @restaurant.update(restaurant_params)
      redirect_to restaurants_path, notice: 'Restaurant was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /restaurants/1
  def destroy
    @restaurant.destroy
    redirect_to restaurants_url, notice: 'Restaurant was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant
      @restaurant = Restaurant.new(restaurant_params)
    end

    # Only allow a trusted parameter "white list" through.
    def restaurant_params
      params.require(:restaurant).permit(:factual_id, :category_ids, :cuisine, :name, :country, 
                                          :region, :locality, :address, :address_extended, :website, 
                                          :email, :tel, :postcode, :hours_display, :latitude, :longitude, :active)
    end

end