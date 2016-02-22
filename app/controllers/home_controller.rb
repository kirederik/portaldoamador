
class HomeController < ApplicationController

  def index
    if current_user.nil?
      redirect_to "users#login"
    end
  end

end
