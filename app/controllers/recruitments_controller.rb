class RecruitmentsController < ApplicationController
  def index
    @recruitments = Recruitment.all
  end
  
  def new
  end

  def create
    @recruitment = Recruitment.new(recruitment_params)

    @recruitment.save!
    redirect_to recruitments_path
  end

  private 
  def recruitment_params
    params.require(:recruitment).permit(:room_name, :room_url, :description)
  end
end
