class RecruitmentsController < ApplicationController
  def index
    @recruitments = Recruitment.all
  end
  
  def new
  end

  def create
    @recruitment = Recruitment.new(params.require(:recruitment).permit(:room_name))

    @recruitment.save!
    redirect_to recruitments_path
  end
end
