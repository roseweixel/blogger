class StudentMailer < ApplicationMailer
  def initial_schedule_notification(schedule, student)
    @schedule = schedule
    @student = student
    @blog_assignments = @student.blog_assignments.where(schedule_id: @schedule.id)

    mail(to: @student.email, subject: "Your Blog Assignments for #{@schedule.name}")
  end
end
