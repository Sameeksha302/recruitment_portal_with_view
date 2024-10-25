class CompaniesController < ApplicationController
    before_action :authenticate_user!
  
    def index
      @companies = Company.all # Fetch all companies from the database
    end
  end
  