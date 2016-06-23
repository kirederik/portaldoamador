require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#is_active" do
    context "when current controller is active" do
      it "returns active" do
        params[:controller] = "current"
        expect(helper.is_active("current")).to eq "active"
      end
    end
    context "when controller is not the current one" do
      it "returns nil" do
        params[:controller] = "not_current"
        expect(helper.is_active("current")).to be_nil
      end
    end
  end

end
