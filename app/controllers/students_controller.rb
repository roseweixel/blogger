class StudentsController < ApplicationController

  def create
    Student.create(student_params)
    redirect_to(:back)
  end

  def edit
    @student = Student.find(params[:id])
  end

  def update
    @student = Student.find(params[:id])
    @student.update(student_params)
    redirect_to(cohort_path(@student.cohort))
  end

  def destroy
    @student = Student.find(params[:id])
    @student.destroy
    redirect_to(:back)
  end

  private 

    def student_params
      params.require(:student).permit(:first_name, :last_name, :email, :github_username, :cohort_id)
    end
end
