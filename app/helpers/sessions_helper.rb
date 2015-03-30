module SessionsHelper
    # www.railstutorial.org
    def log_in(user)
        session[:user_id] = user.id
    end
    
    def current_user
        @current_user ||= User.find_by( id: sesssion[:user_id] )
    end
    
    def logged_in?
        !current_user.nil?
    end
end
