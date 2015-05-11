class StudentMailer < ApplicationMailer
  def initial_schedule_notification(schedule, student)
    @schedule = schedule
    @student = student
    @blog_assignments = @student.blog_assignments.where(schedule_id: @schedule.id)

    mail(to: @student.email, subject: "Your Blog Assignments for #{@schedule.name}")
  end

  def reminder_email(blog_assignment)
    attachments.inline['green_dot.png'] = File.read('app/assets/images/green_dot.png')
    attachments.inline['red_dot.png'] = File.read('app/assets/images/red_dot.png')
    attachments.inline['emtpy_dot.png'] = File.read('app/assets/images/empty_dot.png')

    @blog_assignment = blog_assignment
    @student = blog_assignment.student

    mail(to: @student.email, subject: "Blog post due tomorrow #{@blog_assignment.due_date.strftime("%m/%d")}")
  end
end
