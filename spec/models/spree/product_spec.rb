require 'rails_helper'

RSpec.describe Spree::Product, type: :model do
  describe 'Class RelatedProducts' do
    let(:taxon1) { create(:taxon) }
    let(:taxon2) { create(:taxon) }
    let(:product) { create(:product, taxons: [taxon1, taxon2]) }
    let(:related_products) { create_list(:product, 2, taxons: [taxon1, taxon2]) }
    let(:unrelated_product) { create(:product) }

    it '関連商品がrelated_productsと完全一致し、重複が含まれないこと' do
      expect(product.related_products).to match_array(related_products)
    end

    it '関連しない商品が含まれないこと' do
      expect(product.related_products).not_to include(unrelated_product)
    end
  end
end
