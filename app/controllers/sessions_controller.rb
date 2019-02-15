class SessionsController < ApplicationController
    def new; end
  
    def create
      user = User.find_by email: params[:session][:email].downcase
      
      if user && user.authenticate(params[:session][:password])
        log_in user
        params[:session][:remember_me] == Settings.numble ? remember(user) : forget(user)
        redirect_to user
      else
        flash.now[:danger] = t "danger"
        render :new
      end
    end

    def remember user
        user.remember
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end
    
      def current_user
        if user_id = session[:user_id]
          @current_user ||= User.find_by id: user_id
        elsif user_id = cookies.signed[:user_id]
          user = User.find_by id: user_id
    
          if user&.authenticated?(cookies[:remember_token])
            log_in user
            @current_user = user
          end
        end
      end
    
    def destroy
      log_out if logged_in?
      redirect_to root_url
    end
  end
  