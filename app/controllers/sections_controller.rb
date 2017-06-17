class SectionsController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :index]
  before_action :set_section, only: [:show, :edit, :update, :destroy, :block, :unblock]
  skip_before_action :verify_authenticity_token

  # GET /sections
  # GET /sections.json
  def index
    @sections = Section.all
  end

  # GET /sections/1
  # GET /sections/1.json
  def show
    set_section
    @tests = {}
    @section.tests.each do |test|
      if @tests.has_key?(test.name)
        @tests[test.name][:variants].merge!({test.variant => {id: test.id, questions: test.questions.count}})
      else
        @tests.merge!({test.name => {variants: {test.variant => {id: test.id, questions: test.questions.count}},
                                     come_back: test.come_back, test: test}})
      end
    end
  end

  # GET /sections/new
  def new
    @section = Section.new
  end

  # GET /sections/1/edit
  def edit
  end

  # POST /sections
  # POST /sections.json
  def create
    @section = Section.new(section_params)
    respond_to do |format|
      if @section.save
        format.html {redirect_to sections_path, notice: 'Section was successfully created.'}
      else
        format.html {render :new}
        format.json {render json: @section.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /sections/1
  # PATCH/PUT /sections/1.json
  def update
    respond_to do |format|
      if @section.update(section_params)
        format.html {redirect_to @section, notice: 'Section was successfully updated.'}
        format.json {render :show, status: :ok, location: @section}
      else
        format.html {render :edit}
        format.json {render json: @section.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /sections/1
  # DELETE /sections/1.json
  def destroy
    if @section.blocking
      @section.destroy
      respond_to do |format|
        format.html {redirect_to root_url, notice: 'Section was successfully destroyed.'}
        format.json {head :no_content}
      end
    elsif !@section.blocking
      respond_to do |format|
        format.html {redirect_to root_url, notice: 'Section was not destroyed. Blocking it and destroy again'}
        format.json {head :no_content}
      end
    end
  end

  def block
    set_section.update(blocking: true)
    respond_to do |format|
      format.html {redirect_to root_url, notice: "#{ @section.name } section was successfully blocked."}
      format.json {head :no_content}
    end
  end

  def unblock
    set_section.update(blocking: false)
    respond_to do |format|
      format.html {redirect_to root_url, notice: "#{ @section.name } section was successfully blocked."}
      format.json {head :no_content}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_section
    @section = Section.find_by_id(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def section_params
    params.require(:section).permit(:name)
  end
end
