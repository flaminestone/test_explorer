class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:create]

  before_action :set_user, only: [:show, :edit, :update] # probably want to keep using this

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # # GET /users/1
  # # GET /users/1.json
  def show

  end

  # GET /users/1/edit
  def edit

  end

  def create
    errors = []
    unless params[:user][:password] == params[:user][:password_confirmation]
      errors << t(:password_confirm_faile)
    end
    unless params[:user][:secret] == ENV['Secret']
      errors << t(:secret_faile)
    end
    if errors.empty?
      user = User.create!({:email =>  params[:user][:email], :password =>  params[:user][:password], :password_confirmation =>  params[:user][:password_confirmation] })
      session[:current_user_id] = user.id
      redirect_to '/users/sign_in'
    else
      flash[:error] = errors
      redirect_to new_user_registration_path(User.new())
    end
  end

  # # PATCH/PUT /users/1
  # # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html {redirect_to @user, notice: 'User was successfully updated.'}
        format.json {render :show, status: :ok, location: @user}
      else
        format.html {render :edit}
        format.json {render json: @user.errors, status: :unprocessable_entity}
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:role, :user_name)
  end

end