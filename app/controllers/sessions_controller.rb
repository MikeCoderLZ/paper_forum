class SessionsController < ApplicationController
  # Since the sessions 'model' associated with this controller exists
  # in client-side cookies, there is nothign to set up for the page
  # beyond whatever voodoo Rails is already doing
  def new
      
  end
  # The SessionsController creates sessions objects whose 'model' exists
  # on the client's computer.
  def create
      # The user has entered their log in credentials, so we look them
      # up in the database via their email address, filtered for case
      user = User.find_by( email: params[:session][:email].downcase)
      # Short-circuit evaluation combined with Ruby's unique boolean system
      # in action: if we found a user and they can be authenticated via the
      # provided credentials, THEN we can continue with the log in
      if user && user.authenticate(params[:session][:password])
          # from the SessionsHelper
          log_in user
          # If the user clicked the "remember me" checkbox, then...do that?
          params[:session][:remember_me] == '1' ? remember(user) : forget(user)
          redirect_back_or user
      # stuff
      else
          # Elsewise, add an error flash to the hash
          flash.now[:danger] = 'Invalid email/password combination'
          # and go to the log in screen again
          render 'new'
      end
  end
  
  def destroy
      # naturally, only log out if the user was logged in
      log_out if logged_in?
      # and return them to the root page
      redirect_to root_url
  end
end
