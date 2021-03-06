class TestsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  before_action :set_test, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  # GET /tests
  # GET /tests.json
  def index
    @tests = get_section.tests
  end

  # GET /tests/1
  # GET /tests/1.json
  def show
    set_test
    @section = get_section
    @questions = @test.questions.sort_by { rand }
  end

  # GET /tests/new
  def new
    @test = Test.new
    @section = Section.find_by_id(params.require(:id))
    @question = Question.new
  end

  # GET /tests/1/edit
  def edit
    @section = get_section
    @question = Question.new
    @questions = @test.questions.order("updated_at DESC")
    @variant = Variant.new
  end

  # POST /tests
  # POST /tests.json
  def create
    @test = Test.new(test_params)
    @test.variant = Test.all.where(name: test_params['name']).count + 1
    respond_to do |format|
      if @test.save
        get_section.tests << @test
        format.html { redirect_to edit_section_test_path(get_section, @test), notice: 'Test was successfully created.'}
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /tests/1
  # PATCH/PUT /tests/1.json
  def update
    respond_to do |format|
      if Section.find(params['section_id']).tests.where(name: @test.name).update_all(test_params)
        format.html {redirect_to :back, notice: 'Test was successfully updated.'}
        format.json {render :show, status: :ok, location: @test}
      else
        format.html {render :edit}
        format.json {render json: @test.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /tests/1
  # DELETE /tests/1.json
  def destroy
    @test.destroy
    Test.where(name: @test.name).each_with_index do |current_test, index|
      current_test.update(variant: index + 1)
    end
    respond_to do |format|
      format.html {redirect_to section_path(Section.find_by_id(params[:section_id])), notice: 'Test was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_test
    @test = Test.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def test_params
    params.require(:test).permit(:name, :come_back)
  end

  def get_section
    Section.find(params.require(:section_id))
  end
end
