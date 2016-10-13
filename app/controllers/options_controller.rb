class OptionsController < ApplicationController
  before_action :set_question
  before_action :set_option, only: [:create]
  load_and_authorize_resource except: [:show]
  layout 'admin'
  
  # GET /options
  def index
    @options = @options.where(question_id: @question)
  end

  # GET /options/new
  def new
  end

  # GET /options/1/edit
  def edit
  end

  # POST /options
  def create
    @option.question = @question
    if @option.save
      redirect_to question_options_path, notice: 'Option was successfully created.'
    else
      render :new
    end
  end

  def show
    @option = Option.find(params[:id])
  end

  # PATCH/PUT /options/1
  def update
    if @option.update(option_params)
      redirect_to question_options_path, notice: 'Option was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /options/1
  def destroy
    @option.destroy
    redirect_to question_options_url, notice: 'Option was successfully destroyed.'
  end

  private
    def set_question
      @question = Question.find(params[:question_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_option
      @option = Option.new(option_params)
    end

    # Only allow a trusted parameter "white list" through.
    def option_params
      params.require(:option).permit(:quesiton_id, :title, :deduction, :position)
    end
end