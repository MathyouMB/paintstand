require 'rails_helper'

RSpec.describe(Purchase, type: :model) do
  let(:purchase) { build(:purchase) }

  describe 'Purchase Attribute Validations' do
    let(:result) { purchase.valid? }

    context 'When purchase has no cost' do
      before { purchase.cost = nil }

      it 'returns false' do
        expect(result).to(be(false))
      end
    end

    context 'When purchase has negative cost' do
      before { purchase.cost = -1 }

      it 'returns false' do
        expect(result).to(be(false))
      end
    end
  end
end
