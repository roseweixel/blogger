module PostsHelper
  def cohort_filter_options
    ["Show all"] + Cohort.all.pluck(:name).collect { |cohort_name| "View only posts by #{cohort_name}" }
  end
end
