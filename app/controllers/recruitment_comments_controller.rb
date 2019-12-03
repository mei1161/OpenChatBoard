class RecruitmentCommentsController < ApplicationController
  def create
    @recruitment = Recruitment.find(params[:recruitment_id])
    @recruitment_comment = @recruitment.recruitment_comments.create(comment_params)
  end

  private
   def comment_params
     params.require(:recruitment_comment).permit(:text,:password)
   end
end
