class StudentsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index, :new]

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(students_params)
    respond_to do |format|
      if @student.save
        format.html {redirect_to section_test_path(students_params[:section_result_name], students_params[:test_result_name])}
        session[:current_user_id] = @student.id
      else
        format.html {render :new}
        format.json {render json: @student.errors, status: :unprocessable_entity}
      end
    end
  end

  def students_params
    params.require(:student).permit(:name, :group, :test_result_name, :section_result_name)
  end

  def groups
    @groups = Student.pluck(:group).uniq
  end

  def show
    if params['section_result_name'].nil?
      @data = Student.where(:group => params['group_name']).pluck(:section_result_name).uniq
      @data = Section.all.where(id: @data).pluck(:name)
      @key = :section_result_name
      @name = t(:sections)
    elsif params['test_result_name'].nil?
      @data = Student.where(:group => params['group_name'], :section_result_name => Section.find_by_name(params['section_result_name']).id).pluck(:test_result_name).uniq
      @data = Test.all.where(id: @data).pluck(:name)
      @key = :test_result_name
      @name = t(:tests)
    else
      Student.where(result: nil).destroy_all
      @data = Student.where(group: params['group_name'],
                            section_result_name: Section.find_by_name(params['section_result_name']).id,
                            test_result_name: Test.find_by_name(params['test_result_name']).id).reverse_order
    end
  end
end
