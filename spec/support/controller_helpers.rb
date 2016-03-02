module ControllerHelpers

  def user_sign_in
    fake_sign_in(FactoryGirl.create(:user))
  end

  def admin_sign_in
    admin = FactoryGirl.create(:admin)
    fake_sign_in(admin)
  end

  def fake_sign_in(resource_or_scope = :user, options = {})
    if resource_or_scope.is_a?(Symbol)
      scope = resource_or_scope
      resource = double(resource_or_scope)
    else
      resource = resource_or_scope
      scope = options[:scope] || resource.class.to_s.underscore
    end
    # Since we have multiple scopes we need to check if scope option provided to
    # authenticate! matches scope that we are logging in
    allow(request.env['warden']).to receive(:authenticate!) do |opt|
      if opt[:scope].to_sym == scope.to_sym
        resource
      else
        throw :warden, :scope => scope
      end
    end
    allow(controller).to receive("current_#{scope}").and_return(resource)
  end

  def fake_sign_out(scope = :user)
    allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => scope})
    allow(controller).to receive("current_#{scope}").and_return(nil)
  end

end
