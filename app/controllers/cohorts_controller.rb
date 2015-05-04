require 'csv'

class CohortsController < ApplicationController
  def create
    @cohort = Cohort.create(cohort_params)

    CSV.foreach(@cohort.roster_csv.path).each_with_index do |row, index|
      if index == 0
        @student_attributes_array = row
      else
        student = @cohort.students.new.tap do |s|
          @student_attributes_array.each_with_index do |attribute, index|
            s.send(attribute + '=', row[index])
          end
        end
        student.save
      end
    end

    redirect_to(:back)
  end

  def edit
    @cohort = Cohort.find(params[:id])
  end

  def update
    @cohort = Cohort.find(params[:id])
    @cohort.update(cohort_params)
    redirect_to(cohort_path(@cohort))
  end

  def show
    @cohort = Cohort.includes(students: [:blogs]).find(params[:id])
  end

  def destroy
    @cohort = Cohort.find(params[:id])
    @cohort.destroy
    redirect_to(:back)
  end

  private

    def cohort_params
      params.require(:cohort).permit(:name, :roster_csv)
    end
end
