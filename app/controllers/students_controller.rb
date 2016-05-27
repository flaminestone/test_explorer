class StudentsController < ApplicationController
  def new
    @student = Student.new
  end

  def create
    @student  = Student.new(students_params)
    respond_to do |format|
      if @student.save
        format.html { redirect_to section_test_path(students_params[:section_result_name], students_params[:test_result_name])}
        session[:current_user_id] = @student.id
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  def students_params
    params.require(:student).permit(:name, :group, :test_result_name, :section_result_name)
  end
end
