class UsersController < ApplicationController
  skip_before_filter :authenticate_user, :only => [:login, :logout, :authenticate_client, :create_password]
  skip_before_filter :check_if_user_has_password, :only => [:login, :logout, :authenticate_client, :create_password, :first_login]
  
  def login
    render :layout => false
  end

  def logout
    reset_session
    flash[:notice] = "You have been logged out"
    redirect_to("/login")
  end

  def user_profile
    @user = User.find(session[:user])
    render :layout => 'voter' if @user.role.downcase == 'user'
  end

  def edit_profile
    @user = User.find(session[:user])
    render :layout => 'voter' if @user.role.downcase == 'user'
  end

  def update_my_profle
    phone_number = params[:phone_number]
    first_name = params[:first_name]
    last_name = params[:last_name]
    nick_name = params[:nick_name]

    user = User.find(session[:user])
    user.phone_number = phone_number
    user.first_name = first_name
    user.last_name = last_name
    user.nick_name = nick_name
    if user.save
      flash[:notice] = "You have succesfully edited your details"
    else
      flash[:notice] = user.errors.first.last
    end

    redirect_to("/user_profile") and return
  end

  def change_password
    @user = User.find(session[:user])
    render :layout => 'voter' if @user.role.downcase == 'user'
  end

  def update_password
    user = User.find(session[:user])
    old_password = params[:old_password]
    password = params[:password]
    password_confirm = params[:confirm_password]

    check_old_password = User.authenticate(user.phone_number, old_password)
    errors = []
    errors << "Old password is not correct" if !check_old_password
    errors << "Password Mismatch" if (password != password_confirm)

    unless errors.blank?
      flash[:notice] = errors.join(', ')
      redirect_to("/change_password") and return
    end

    user.password = User.encrypt(password, user.salt)
    user.save

    flash[:notice] = "You have successfully changed your password"
    redirect_to("/user_profile") and return
  end

  def authenticate_client
    user = User.find_by_phone_number(params[:phone_number])
    if !user
      flash[:notice] = "The phone number entered does not exist in our database"
      redirect_to("/login") and return
    end

    if user && user.password.blank?
      session[:user] = user
      flash[:notice] = "This is your first login. Create your password to secure your account"
      redirect_to("/first_login") and return
    end

    logged_in_user = User.authenticate(params[:phone_number], params[:password])
    if logged_in_user
      session[:user] = user
      if user.role.downcase == 'admin'
        redirect_to("/") and return
      else
        ip_address = request.remote_ip
        User.track_user(user.user_id, ip_address)
        redirect_to("/voter") and return
      end
      
    else
      flash[:notice] = "Wrong Password"
      redirect_to("/login") and return
    end
  end

  def first_login
    @user = session[:user]
    render :layout => 'voter'
  end

  def create_password
    password = params[:password]
    password_confirm = params[:confirm_password]
    
    if (password != password_confirm)
      flash[:notice] = "Password Mismatch. Try again"
      redirect_to("/first_login") and return
    end

    user = session[:user]
    salt = user.salt
    salt = User.random_string(10) if salt.blank?
    
    user.password = User.encrypt(password, salt)
    user.salt = salt if user.salt.blank?
    user.save
    
    session.delete(:first_login)
    session[:user] = user
    redirect_to("/voter") and return
  end

end
