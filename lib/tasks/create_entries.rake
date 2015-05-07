namespace :blog_entries do
  task :create_entries => :environment do
    Blog.all.each do |blog|
      blog.create_entries
    end
  end
end
