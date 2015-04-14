module SessionsHelper
    # www.railstutorial.org
    # log the given user in
    def log_in(user)
        # The session hash creates temporary cookies on the client's browser
        # The functionality is encrypted by default, and expires when the
        # browser is closed.
        # Here, we are creating an encrypted copy of the user's ID
        session[:user_id] = user.id
    end
    
    def remember(user)
        # Updates User's remember_token and it's corresponding digest
        user.remember
        # Create two effectively permanent cookies on the client browser
        # the cookies hash works liek the session hash, except it is not
        # encrypted of it's own accord. Hence the use of the signed hash
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end
    
    def current_user?(user)
        # I would posit that Rails' Model class redefines the equality
        # operator, since NORMALLY '==' in reference based languages
        # compares the value of the reference, not the values in the
        # in the referant
        user == current_user
    end
    
    def forget( user )
        # This clears the remember digest
        user.forget
        # This removes the cookies from the client's browser
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end
    
    def log_out
        # as above: clear out all remember me data
        forget(current_user)
        # also destroy the current session
        session.delete(:user_id)
        # and clear the current user
        @current_user = nil
    end
    
    def current_user
        # capture the user_id if the temporary session is live...
        # the default return value of a hash for keys it does not contain
        # is nil
        if (user_id = session[:user_id] )
            @current_user ||= User.find_by( id: user_id )
        # otherwise capture it from the persistent session credentials
        elsif (user_id = cookies.signed[:user_id])
            user = User.find_by( id: user_id )
            # if we can authenticate the remember token...
            if user && user.authenticated?(:remember, cookies[:remember_token])
                # login
                log_in user
                @current_user = user
            end
        end
    end
    
    def logged_in?
        # Only true if the current user is not nil
        !current_user.nil?
    end
    
    def redirect_back_or(default)
        # Serve up the address stored in the forwarding attribute
        # which is stored in client cookies
        redirect_to( session[:forwarding_url] || default )
        # Clear out the forwarding cookie
        session.delete(:forwarding_url)
    end
    
    # Store the location in the session
    def store_location
        # this uses a client cookie, but only if the request
        # also, it assumes the local scope has access to the
        # request object. This works because Ruby is interpreted
        # AND the SessionsHelper is included in the
        # ApplicationController
        session[:forwarding_url] = request.url if request.get?
    end
    
end
