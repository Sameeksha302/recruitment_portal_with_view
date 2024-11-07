class CompaniesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  # GET /companies
  # List all companies
  def index
    @companies = Company.all
  end

  # GET /companies/:id
  # Show a specific company
  def show
  end

  # GET /companies/new
  # Form to create a new company
  def new
    @company = Company.new
  end

  # POST /companies
  # Create a new company
  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to @company, notice: 'Company was successfully created.'
    else
      # flash.now[:alert] = @company.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  # GET /companies/:id/edit
  # Form to edit an existing company
  def edit
  end

  # PATCH/PUT /companies/:id
  # Update an existing company
  def update
    if @company.update(company_params)
      redirect_to @company, notice: 'Company was successfully updated.'
    else
      # flash.now[:alert] = @company.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /companies/:id
  # Delete a company
  def destroy
    @company.destroy
    flash[:notice] = 'Company was successfully deleted.'
    redirect_to companies_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_company
    @company = Company.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def company_params
    params.require(:company).permit(:name, :address, :industry_type)
  end
end
