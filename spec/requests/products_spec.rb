require 'rails_helper'

RSpec.describe "Products Page", type: :request do
  describe "GET /products/:show" do
    let(:taxon) { create(:taxon) }
    let!(:product) { create(:product, taxons: [taxon]) }

    before do
      get spree.product_path(product.id)
    end

    it '商品名が含まれること' do
      expect(response.body).to include product.name
    end

    it '商品詳細ページが200で返ること' do
      expect(response).to have_http_status(:ok)
    end

    it '価格が含まれること' do
      expect(response.body).to include product.display_price.to_s
    end
  end

  describe "Breadcrumb Test" do
    let(:root_category) { create(:taxon, name: 'Categories', parent: nil) }
    let(:different_category) { create(:taxon, name: 'different', parent: root_category) }
    let(:child_category) { create(:taxon) }
    let!(:product) { create(:product, taxons: [different_category]) }

    before do
      get spree.product_path(product.id)
    end

    it "Breadcrumbに最上位カテゴリCategoriesが含まれること" do
      expect(response.body).to include root_category.name
    end

    it "Breadcrumbにchild_category.nameが含まれないこと" do
      expect(response.body).not_to include child_category.name
    end

    it "Breadcrumbにdifferent_category.nameが含まれること" do
      expect(response.body).to include different_category.name
    end
  end
end
