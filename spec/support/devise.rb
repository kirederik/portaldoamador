require 'devise'
require 'support/controller_macros'
RSpec.configure do |config|
  Devise.stretches = 1
  config.include Devise::TestHelpers, :type => :controller
  config.extend ControllerMacros, :type => :controller
end
