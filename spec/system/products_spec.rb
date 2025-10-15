require 'rails_helper'

RSpec.describe "product/show/:id", type: :system do
  let(:root) { create(:taxon, parent: nil) }
  let(:other_taxon) { create(:taxon, parent: root) }
  let(:taxon) { create(:taxon, name: 'taxon', parent: other_taxon) }
  let!(:product) { create(:product, taxons: [taxon]) }
  let(:image) { create(:image) }

  before do
    product.images << image
    visit product_path(product.id)
  end

  describe "products/show Crass Container ProductsContainer Test" do
    it "Crass ProductDetail__name, product.nameが表示されること" do
      within('.ProductDetail__name') do
        expect(page).to have_content(product.name)
      end
    end
  end

  describe "Breadcrumb Test" do
    it "Breadcrumb, taxon.name click, taxon.name一覧へ遷移すること" do
      within('.Breadcrumb') do
        click_on taxon.name
        expect(current_path).to eq category_path(taxon.id)
      end
    end

    it "Breadcrumb, other_taxon linkが表示されること" do
      within('.Breadcrumb') do
        expect(page).to have_link(other_taxon.name)
      end
    end

    it "Breadcrumb, taxon.name linkが表示されること" do
      within('.Breadcrumb') do
        expect(page).to have_link(taxon.name)
      end
    end

    it "Breadcrumb, product.nameが表示されること" do
      within('.Breadcrumb') do
        expect(page).to have_content(product.name)
      end
    end
  end
end
