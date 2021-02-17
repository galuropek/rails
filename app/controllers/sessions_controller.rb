class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params.dig(:session, :email).downcase)
    if user && user.authenticate(params.dig(:session, :password))
      # todo - log in
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
  end
end
