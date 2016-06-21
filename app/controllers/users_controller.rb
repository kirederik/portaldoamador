class UsersController < ApplicationController

  def index
    isAdmin do
      @users = User.all
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @users }
      end
    end
  end

  def new
    isAdmin do
      @user = User.new
      respond_to do |format|
        format.html
      end
    end
  end

  def create
    isAdmin do
      @user = User.new(user_params)
      respond_to do |format|
        if @user.save
          format.html { redirect_to @user, notice: 'Usuário criado com sucesso' }
          format.json { render action: 'show', status: :created, location: @user }
        else
          puts @user.errors.full_messages
          format.html { render action: 'new' }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # GET /users/id
  def show
    isAdmin do
      @user = User.find(params[:id])
    end
  end

  private

  def user_params
    params.require(:user).permit(:fullname, :email, :password, :phone, :copynumber, :password_confirmation)
  end

end
