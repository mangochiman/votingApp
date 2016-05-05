class UsersController < ApplicationController
  skip_before_filter :authenticate_user, :only => [:login, :authenticate_client, :first_login]
  
  def login
    render :layout => false
  end

  def logout
    redirect_to("/login")
  end

  def user_profile
    render :layout => false
  end

  def authenticate_client
    raise params.inspect
    user = User.find_by_phone_number(params[:phone_number])
    if !user
      flash[:notice] = "<b>#{params[:phone_number]}</b> is not registered in our database"
      redirect_to("/login") and return
    end

    if user && user.password.blank?
      session[:first_login] = user
      flash[:notice] = "This is your first login. Create your password to secure your account"
      redirect_to("/first_login")
    end

    logged_in_user = User.authenticate(params[:phone_number], params[:password])
    if logged_in_user
      session.delete(:first_login)
      session[:user] = user
      redirect_to("/") and return
    else
      flash[:error] = "Invalid username or password"
      redirect_to :controller => "user", :action => "login" and return
    end
  end

  def first_login
    redirect_to("/login") if session[:first_login].blank?
    @user = session[:first_login]
    render :layout => 'voter'
  end

  def create_password
    password = params[:password]
    password_confirm = params[:confirm_password]
    
    if (password != password_confirm)
      flash[:notice] = "Password Mismatch. Try again"
      redirect_to("/first_login") and return
    end

    user = session[:first_login]
    salt = user.salt
    salt = User.random_string(10) if salt.blank?
    
    user.password = password
    user.salt = salt if user.salt.blank?
    user.save
    
    session.delete(:first_login)
    session[:user] = user
    redirect_to("/voter") and return
  end

end
