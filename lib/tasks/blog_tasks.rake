namespace :blogs do
  task :create_entries => :environment do
    Blog.all.each do |blog|
      blog.create_entries
    end
  end

  task :set_titles => :environment do
    Blog.all.each do |blog|
      blog.set_title
    end
  end

  task :send_reminder_emails => :environment do
    BlogAssignment.due_tomorrow.each do |blog_assignment|
      StudentMailer.reminder_email(blog_assignment).deliver_now
    end
  end
end
