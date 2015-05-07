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
end
