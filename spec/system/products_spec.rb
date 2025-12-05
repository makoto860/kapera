require 'rails_helper'

RSpec.describe "product/show/:id", type: :system do
  let!(:root_taxon) { create(:taxon, name: "Categories") }
  let(:parent_taxon) { create(:taxon, parent: root_taxon) }
  let(:child_taxon) { create(:taxon, name: 'child', parent: parent_taxon) }
  let!(:image) { create(:image) }
  # 1つのブロックでproductの生成と画像紐付けを同時に完結
  let!(:product) do
    create(:product, taxons: [child_taxon]).tap do |product|
      product.images << image
    end
  end
  # 4件のrelated_product を生成。順番に名前を"Related Product 1"～"Related Product 4"に設定。それぞれに画像を紐付け。let!で生成しているのでテスト開始前にすべてDBに存在する処理
  let!(:related_products) do
    create_list(:product, 4, taxons: [child_taxon]) do |related_product, i|
      related_product.update!(name: "Related Product #{i + 1}")
      create(:image, viewable: related_product.master)
    end
  end

  before do
    visit product_path(product.id)
  end

  describe "class Container ProductsContainer Test" do
    it "viewの一緒に見られている商品の場所で関連商品が表示されている" do
      within('.RelatedProducts') do
        related_products.each do |related_product|
          expect(page).to have_content(related_product.name)
        end
      end
    end

    it "class ProductDetail__name, product.nameが表示されること" do
      within('.ProductDetail__name') do
        expect(page).to have_content(product.name)
      end
    end
  end

  describe "shared/_breadcrumb.html.erb Test" do
    it "class Breadcrumbでchild_taxon.nameをクリックすると、そのカテゴリの商品一覧ページへ遷移すること" do
      within('.Breadcrumb') do
        click_on child_taxon.name
        expect(current_path).to eq category_path(child_taxon.id)
      end
    end

    it "class Breadcrumbでparent_taxon.nameリンクが表示されること" do
      within('.Breadcrumb') do
        expect(page).to have_link(parent_taxon.name)
      end
    end

    it "class Breadcrumbでchild_taxon.nameリンクが表示されること" do
      within('.Breadcrumb') do
        expect(page).to have_link(child_taxon.name)
      end
    end

    it "class Breadcrumbでproduct.nameが表示されること" do
      within('.Breadcrumb') do
        expect(page).to have_content(product.name)
      end
    end
  end
end
