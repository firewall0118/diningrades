class QuestionsController < ApplicationController
  before_action :set_question, only: [:create]
  load_and_authorize_resource except: [:show]
  layout 'admin'
  
  # GET /questions
  def index
  end

  # GET /questions/new
  def new
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions
  def create
    if @question.save
      redirect_to questions_path, notice: 'Question was successfully created.'
    else
      render :new
    end
  end

  def show
    @question = Question.find(params[:id])
  end

  # PATCH/PUT /questions/1
  def update
    if @question.update(question_params)
      redirect_to questions_path, notice: 'Question was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /questions/1
  def destroy
    @question.destroy
    redirect_to questions_url, notice: 'Question was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.new(question_params)
    end

    # Only allow a trusted parameter "white list" through.
    def question_params
      params.require(:question).permit(:question, :extended, :category, :position)
    end
end