require 'rails_helper'

RSpec.describe(Image, type: :model) do
  let(:image) { build(:image) }

  describe 'Image Attribute Validations' do
    let(:result) { image.valid? }

    context 'When image has no title' do
      before { image.title = nil }

      it 'returns false' do
        expect(result).to(be(false))
      end
    end

    context 'When image has no price' do
      before { image.price = nil }

      it 'returns false' do
        expect(result).to(be(false))
      end
    end

    context 'When image has invalid state' do
      before { image.state = 'invalid' }

      it 'returns false' do
        expect(result).to(be(false))
      end
    end

    context 'When image has negative price' do
      before { image.price = -1 }

      it 'returns false' do
        expect(result).to(be(false))
      end
    end
  end
end
