require "rails_helper"

RSpec.describe(Tag, type: :model) do
  let(:tag) { build(:tag) }

  describe "Tag Attribute Validations" do
    let(:result) { tag.valid? }

    it "valid tag" do
      expect(result).to(be(true))
    end

    context "when tag has no name" do
      before { tag.name = nil }

      it "returns false" do
        expect(result).to(be(false))
      end
    end

    context "when two tags have the same name" do
      let(:tag_copy) { create(:tag, name: tag.name) }

      before do
        tag.name = tag_copy.name
      end

      it "returns false" do
        expect(result).to(be(false))
      end
    end
  end
end
