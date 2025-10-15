require 'rails_helper'

RSpec.describe "categories/show/:id", type: :system do
  let(:root) { create(:taxon, name: 'Categories', parent: nil) }

  describe ".Breadcrumb TEST" do
    let(:deffernt_category) { create(:taxon, parent: root) }
    let(:category) { create(:taxon, parent: deffernt_category) }
    let!(:product) { create(:product, price: 1, taxons: [category]) }

    before do
      visit category_path(deffernt_category.id)
    end

    it "Breadcrumb, category.name linkが表示されること" do
      visit category_path(category.id)
      within('.Breadcrumb') do
        expect(page).to have_link(category.name)
      end
    end

    it "Breadcrumb, deffent_category.nameが表示されること" do
      visit category_path(category.id)
      within('.Breadcrumb') do
        expect(page).to have_link(deffernt_category.name)
      end
    end

    it 'Breadcrumb, category.name link表示されないこと' do
      within('ul.Breadcrumb') do
        expect(page).not_to have_link(category.name, href: category_path(category.id))
      end
    end

    it 'Breadcrumb, category.name link表示されること' do
      visit category_path(category.id)
      within('.Breadcrumb') do
        expect(page).to have_link(category.name)
      end
    end

    it "Breadcrumb, ホームが表示されており、clickでホームに遷移できること" do
      visit category_path(category.id)
      within('.Breadcrumb') do
        click_on 'ホーム'
        expect(current_path).to eq root_path
      end
    end

    it 'Breadcrumb, product.name表示されないこと' do
      visit category_path(category.id)
      within('.Breadcrumb') do
        expect(page).not_to have_content(product.name)
      end
    end

    it 'Breadcrumb, deffernt.name linkが表示されること' do
      visit category_path(category.id)
      within('.Breadcrumb') do
        expect(page).to have_link(deffernt_category.name)
      end
    end
  end

  describe "categories/show/id, ul Class CategoryProducts__list TEST" do
    let(:other_taxon) { create(:taxon, parent: root) }
    let(:taxon) { create(:taxon, parent: other_taxon) }
    # 画像がある商品を作成、ない場合除外され失敗する
    let!(:product) do
      create(:product, price: 1, taxons: [taxon]) do |product|
        create(:image, viewable: product.master)
      end
    end
    # 他の別カテゴリ商品画像がある商品を作成、ない場合除外され失敗する
    let!(:other_product) do
      create(:product, price: 2, taxons: [other_taxon]) do |product|
        create(:image, viewable: product.master)
      end
    end

    it "Class CategoryProducts__list, other_product.nameが表示されないこと" do
      visit category_path(taxon.id)
      within(".CategoryProducts__list") do
        expect(page).not_to have_content other_product.name
      end
    end

    it "Class CategoryProducts__list, product.nameが表示されること" do
      visit category_path(other_taxon.id)
      within(".CategoryProducts__list") do
        expect(page).to have_content(product.name)
      end
    end

    it "Class CategoryProducts__list, other_product.display_priceが表示されないこと" do
      visit category_path(taxon.id)
      within(".CategoryProducts__list") do
        expect(page).not_to have_content other_product.display_price
      end
    end
  end

  describe "layouts/_header, ul Crass NavigationMenuList Test" do
    let!(:clothing) { create(:taxon, name: 'Clothing', parent: root) }
    let!(:caps)     { create(:taxon, name: 'Caps', parent: root) }
    let!(:bags)     { create(:taxon, name: 'Bags', parent: root) }
    let!(:mugs)     { create(:taxon, name: 'Mugs', parent: root) }

    before do
      visit category_path(clothing.id)
    end

    it "layouts/_header, ul Crass .NavigationMenuList, 最上位カテゴリ(Categories)が表示されないこと" do
      within(".NavigationMenuList") do
        expect(page).not_to have_content root.name
      end
    end

    it "layouts/_header, ul Crass .NavigationMenuList, 最上位カテゴリ(Categories)下のnameが表示されること" do
      within(".NavigationMenuList") do
        expect(page).to have_content clothing.name
        expect(page).to have_content caps.name
        expect(page).to have_content bags.name
        expect(page).to have_content mugs.name
      end
    end
  end
end
