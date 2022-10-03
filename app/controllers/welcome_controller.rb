class WelcomeController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :destroy]

  def index
    if user_signed_in?
      redirect_to projects_path
    end
  end
end
