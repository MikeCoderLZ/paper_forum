class UsersController < ApplicationController
    # Before edit and update, make sure a user in logged in
    before_action :logged_in_user, only: [:edit, :update]
    before_action :correct_user,   only: [:edit, :update]
    
    def index
        @users = User.all
    end
    
    def show
       @user = User.find(params[:id]) 
    end
    
    def new
        @user = User.new        
    end
    
    def create
        @user = User.new( user_params )
        
        if @user.save
            log_in @user
            flash[:welcome] = "Welcome to the form."
            redirect_to @user
        else
            render 'new'
        end        
    end
    
    def edit
        @user = User.find(params[:id])
    end
    
    def update
        # Notice the parallelism with the create method
        @user = User.find(params[:id])
        if @user.update_attributes(user_params)
            flash[:success] = "Profile updated."
            redirect_to @user
        else
            render 'edit'
        end
    end
    
    private
        def user_params
            params.require(:user).permit( :name, :email, :password,
                                          :password_confirmation )
        end
        # Redirect to the root unless someone is logged in
        def logged_in_user
            unless logged_in?
                store_location
                flash[:danger] = "Please log in."
                redirect_to login_url
            end
        end
        # Make sure the correct user is using the controller
        def correct_user
            @user = User.find(params[:id])
            redirect_to(root_url) unless  current_user?(@user)
        end
end
