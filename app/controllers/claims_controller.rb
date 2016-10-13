class ClaimsController < ApplicationController
  before_action :set_claim, only: [:create]
  load_and_authorize_resource except: [:show]
  layout 'admin'
  
  # GET /claims
  def index
    authorize! :manage, Claim
    @claims = Claim.includes(:restaurant, :user).where(active: true)
    @claims = @claims.page(params[:page])
  end

  # GET /claims/new
  def new
  end

  # GET /claims/1/edit
  def edit
  end

  # POST /claims
  def create
    if @claim.save
      redirect_to claims_path, notice: 'claim was successfully created.'
    else
      render :new
    end
  end

  def show
    @claim = claim.find(params[:id])
  end

  # PATCH/PUT /claims/1
  def update
    if @claim.update(claim_params)
      UserRestaurant.where(user_id: @claim.user_id, restaurant_id: @claim.restaurant_id).first_or_create
      redirect_to claims_path, notice: 'claim was successfully processed.'
    else
      render :edit
    end
  end

  # DELETE /claims/1
  def destroy
    @claim.destroy
    redirect_to claims_url, notice: 'claim was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_claim
      @claim = Claim.new(claim_params)
    end

    # Only allow a trusted parameter "white list" through.
    def claim_params
      params.require(:claim).permit(:restaurant_id, :user_id, :first_name, :last_name, :email, 
                                          :tel, :address, :locality, :region, :zipcode, :active)
    end
end