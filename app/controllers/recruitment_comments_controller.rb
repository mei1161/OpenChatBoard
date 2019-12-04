class RecruitmentCommentsController < ApplicationController
  def create
    @recruitment = Recruitment.find(params[:recruitment_id])

      pp '===================='
      pp @recruitment_comment
      pp '===================='
    if params[:reply_to]
      # parent = @recruitment.recruitment_comments.find(params[:reply_to])
      @recruitment_comment = @recruitment.recruitment_comments.new(comment_params)
      @recruitment_comment.parent_id = params[:reply_to]
    else
      @recruitment_comment = @recruitment.recruitment_comments.new(comment_params)
    end

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
