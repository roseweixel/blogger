class MembershipsController < ApplicationController
  def create
    @membership = Membership.create(membership_params)
    redirect_to cohort_path(@membership.cohort)
  end

  def destroy
    @membership = Membership.find(params[:id])
    @membership.destroy
    redirect_to(:back)
  end

  private

    def membership_params
      params.require(:membership).permit(:user_id, :cohort_id)
    end
end
