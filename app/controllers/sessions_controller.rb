class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(login_params[:email])
    # If the user exists AND the password entered is correct.
    if user && user.authenticate(login_params[:password])
      # Save the user id inside the browser cookie. This is how we keep the user
      # logged in when they navigate around our website.
      session[:user_id] = user.id
      redirect_to certificates_path
    else
      # If user's login doesn't work, send them back to the login form.
      redirect_to '/login'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/login'
  end

  private

  def login_params
    params.require(:user).permit(:email, :password)
  end

end
