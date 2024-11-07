class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  def index
    @companies = Company.all
  end


  def show
  end


  def new
    @company = Company.new
  end


  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to @company, notice: 'Company was successfully created.'
    else
      # flash.now[:alert] = @company.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

 
  def edit
  end


  def update
    if @company.update(company_params)
      redirect_to @company, notice: 'Company was successfully updated.'
    else
      # flash.now[:alert] = @company.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end


  def destroy
    @company.destroy
    flash[:notice] = 'Company was successfully deleted.'
    redirect_to companies_path
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name, :address, :industry_type)
  end
end
