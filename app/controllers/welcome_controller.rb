class WelcomeController < ApplicationController
  def index
    @cohorts = Cohort.all
    @cohort = Cohort.new
  end
end
