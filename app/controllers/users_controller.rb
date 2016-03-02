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

end
