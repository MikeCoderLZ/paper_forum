class UsersController < ApplicationController
    # Before edit and update, make sure a user in logged in
    before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
    # ^ method ^     |              ^ options hash, with a hash value
    #                ^ symbol of target method
    # Ensure that the correct user is logged in on edit and update
    before_action :correct_user,   only: [:edit, :update]
    before_action :admin_user, only: :destroy
    
    # Serves up the index page, providing a variable with an array
    # of all users in the database
    def index
        @users = User.paginate( page: params[:page])
    end
    # Serves up the individual user page, providing a variable with the
    # user to extract information from
    def show
       @user = User.find(params[:id]) 
    end
    # Serves up the new page and provides a blank dummy user variable.
    # This is partly due to the template having a partial that takes a
    # User variable as input used for BOTH new and edit
    def new
        @user = User.new        
    end
    
    def create
        # Use strong parameters to admit only permitted params
        @user = User.new( user_params )
        # If the user in play manages to save...
        if @user.save
            # Log the use in using the SessionHelper method
            log_in @user
            # Add a message to the flash hash
            flash[:welcome] = "Welcome to the form."
          # ^ hash  ^ key      ^ message
            # Now that we are saved, go to the show page for a user
            redirect_to @user
        else
            # OTHERWISE, loop back to the new page.
            # The local @user object has not changed, and the save method
            # with populate the User object's errors hash with information.
            # The page will take care of displaying this info
            render 'new'
            
        end        
    end

    def edit
        @user = User.find(params[:id])
    end
    
    def update
        # Notice the parallelism with the create method
        @user = User.find(params[:id])
        # Instead of save, we use the update_attributes method
        # which is way longer and not at all similar looking :P
        if @user.update_attributes(user_params)
            flash[:success] = "Profile updated."
            redirect_to @user
        else
            # We also render the edit page instead of the new page, naturally
            render 'edit'
        end
    end
    
    def destroy
        User.find(params[:id]).destroy
        flash[:success] = "User deleted"
        redirect_to users_url
    end
    
    private
        # This method deals with strong parameters.
        def user_params
            params.require(:user).permit( :name, :email, :password,
                                          :password_confirmation )
        end
        # This makes sure that actions only logged in users should have
        # access to will only be done by logged in users
        def logged_in_user
            # Nothing happens, unless...
            unless logged_in?
                # The user is logged in, and then we store the target of
                # their request
                store_location
                # Tell them they must log in using the flash hash
                flash[:danger] = "Please log in."
                # And redirect to the login page
                redirect_to login_url
            end
        end
        # Make sure the correct user is using the controller
        def correct_user
            @user = User.find(params[:id])
            # This action is simply illegal if a user tries to target
            # actions controlled by another user, so we go to the root
            # ...for now
            redirect_to(root_url) unless  current_user?(@user)
        end
        
        def admin_user
            redirect_to(root_url) unless current_user && current_user.admin?
        end
end
