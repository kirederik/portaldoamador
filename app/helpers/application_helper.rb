module ApplicationHelper
  def is_active(ctrl)
   'active' if params[:controller] == ctrl
  end
end
