class RecruitmentsController < ApplicationController
  def index
    @recruitments = Recruitment.all
  end
  
  def show
    @recruitment = Recruitment.find(params[:id])
  end

  def new
    @recruitment = Recruitment.new
  end

  
  def destroy
    @recruitment = Recruitment.find(params[:id])

    password_authenticate(recruitment:@recruitment,params:params)

    @recruitment.destroy
    redirect_to recruitments_path

  end

  def create
    @recruitment = Recruitment.new(recruitment_params)

    if @recruitment.save
      flash[:notice] = "Create new"
      redirect_to recruitments_path
    else
      flash[:notice] = @recruitment.errors.full_messages
      redirect_to new_recruitment_path
    end
  end

  def edit
    @recruitment = Recruitment.find(params[:id])
  end

  def update
    @recruitment = Recruitment.find(params[:id])

    password_authenticate(recruitment:@recruitment,params:recruitment_params)

    @recruitment.update(recruitment_params)
    flash[:notice] = "update success"

    redirect_to recruitments_path
  end

  private 
  def recruitment_params
    params.require(:recruitment).permit(:room_name, :room_url, :description,:password)
  end

  def password_authenticate(recruitment:,params:)
    unless recruitment.authenticate(params['password'])
      flash[:notice] = "Password Invalid"
      redirect_to edit_recruitment_path(recruitment) and return
    end
  end

end
