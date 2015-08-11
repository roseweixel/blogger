class BlogAssignmentsController < ApplicationController
  
  def update
    @blog_assignment = BlogAssignment.find(params[:id])
    if @blog_assignment.update(blog_assignment_params)
      flash[:success] = "Update successfull!"
    else
      flash[:alert] = @blog_assignment.errors.full_messages.to_sentence
    end
    redirect_to(:back)
  end

  private
  
    def blog_assignment_params
      params.require(:blog_assignment).permit(:post_id)
    end
end
