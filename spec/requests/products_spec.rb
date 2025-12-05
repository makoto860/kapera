require 'rails_helper'

RSpec.describe "Products Page", type: :request do
  describe "GET /products/:id" do
    let!(:root_taxon) { create(:taxon, name: 'Categories') }
    let(:taxon) { create(:taxon, parent: root_taxon) }
    let(:image) { create(:image) }
    let(:product) do
      create(:product, taxons: [taxon]).tap do |product|
        product.images << image
      end
    end
    let!(:related_products) do
      create_list(:product, 5, taxons: [taxon]) do |related_product|
        create(:image, viewable: related_product.master)
      end
    end

    before do
      get product_path(product.id)
    end

    it '関連商品の名前と価格が含まれること' do
      related_products[0..3].each do |related_product|
        expect(response.body).to include(related_product.name)
        expect(response.body).to include(related_product.display_price.to_s)
      end
    end

    it '関連商品が5件目は含まれないこと' do
      expect(response.body).not_to include(related_products[4].name)
    end

    it "商品名が含まれること" do
      expect(response.body).to include(product.name)
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
    let(:parent_category) { create(:taxon, name: 'parent_category', parent: root_category) }
    let(:child_category) { create(:taxon) }
    let!(:product) { create(:product, taxons: [parent_category]) }

    before do
      get spree.product_path(product.id)
    end

    it "Breadcrumbに最上位カテゴリCategoriesが含まれること" do
      expect(response.body).to include root_category.name
    end

    it "Breadcrumbにchild_category.nameが含まれないこと" do
      expect(response.body).not_to include child_category.name
    end

    it "Breadcrumbにparent_category.nameが含まれること" do
      expect(response.body).to include parent_category.name
    end
  end
end
