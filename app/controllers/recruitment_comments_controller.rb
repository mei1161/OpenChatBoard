class RecruitmentCommentsController < ApplicationController
  def create
    @recruitment = Recruitment.find(params[:recruitment_id])
    @recruitment_comment = @recruitment.recruitment_comments.new(comment_params)
    @recruitment_comment.save!
    redirect_to recruitments_path
  end

  def destroy
  end

  private
   def comment_params
     params.require(:recruitment_comment).permit(:text,:password)
   end
end
