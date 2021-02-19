class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params.dig(:session, :email).downcase)
    if user && user.authenticate(params.dig(:session, :password))
      log_in user
      redirect_to user
    else
      flash.now[:danger] = "Invalid email/password combination"
    end
  end

  def destroy
  end
end

render 'new'