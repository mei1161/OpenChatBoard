class RecruitmentCommentsController < ApplicationController
  def create
    @recruitment = Recruitment.find(params[:recruitment_id])

    if reply_comment_params[:reply_to]
      parent = @recruitment.recruitment_comments.find(reply_comment_params[:reply_to])
      @recruitment_comment = parent.children.new(comment_params)
      @recruitment_comment.recruitment_id = params[:recruitment_id]
    else
      @recruitment_comment = @recruitment.recruitment_comments.new(comment_params)
    end

    @recruitment_comment.save!
    redirect_to recruitments_path
  end

  def destroy
    @recruitment = Recruitment.find(params[:recruitment_id])
    @recruitment_comment = @recruitment.recruitment_comments.find(params[:id])

    unless @recruitment_comment.authenticate(comment_params[:password])
      show_authentication_error
      redirect_to recruitments_path and return
    end

    if @recruitment_comment.destroy
      flash[:notice] = "delete success"
      redirect_to recruitments_path
    end
     #   <%= link_to 'Delete',[comment.recruitment,comment],method: :delete,data: { confirm: 'Are you sure?' } %>
# 
  end

  private
   def reply_comment_params
     params.require(:recruitment_comment).permit(:text, :password, :reply_to)
   end
   def comment_params
     params.require(:recruitment_comment).permit(:text,:password)
   end
   def  show_authentication_error
     flash[:notice] = "Password invalid"
   end
end
