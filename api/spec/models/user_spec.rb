require "rails_helper"

RSpec.describe(User, type: :model) do
  let(:user) { build(:user) }

  describe "User Attribute Validations" do
    let(:result) { user.valid? }

    it "valid user" do
      expect(result).to(be(true))
    end

    context "when user has no username" do
      before { user.username = nil }

      it "returns false" do
        expect(result).to(be(false))
      end
    end

    context "when two user have the same username" do
      let(:user_copy) { create(:user, username: "test@email.com") }

      before do
        user.username = user_copy.username
      end

      it "returns false" do
        expect(result).to(be(false))
      end
    end

    context "when user has no email" do
      before { user.email = nil }

      it "returns false" do
        expect(result).to(be(false))
      end
    end

    context "when two user have the same email" do
      let(:user_copy) { create(:user, email: "test@email.com") }

      before do
        user.email = user_copy.email
      end

      it "returns false" do
        expect(result).to(be(false))
      end
    end

    context "when user has no password" do
      before { user.password_digest = nil }

      it "returns false" do
        expect(result).to(be(false))
      end
    end

    context "when user has no role" do
      before { user.role = nil }

      it "returns false" do
        expect(result).to(be(false))
      end
    end

    context "when user has invalid role" do
      before { user.role = "invalid" }

      it "returns false" do
        expect(result).to(be(false))
      end
    end
  end
end
