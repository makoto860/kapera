require 'rails_helper'

RSpec.describe "Categories/show/:id", type: :request do
  let(:root_taxon) { create(:taxon, parent: nil) }
  let(:other_parent_taxon) { create(:taxon, parent: root_taxon) }
  let(:taxon) { create(:taxon, name: 'taxon') }
  let!(:product) { create(:product, taxons: [other_parent_taxon]) }

  before do
    get category_path(taxon.id)
  end

  it "product.nameが含まれないこと" do
    expect(response.body).not_to include product.name
  end

  it 'other_parent_taxon.nameが含まれないこと' do
    expect(response.body).not_to include(other_parent_taxon.name)
  end

  it 'taxon.nameが含まれること' do
    expect(response.body).to include(taxon.name)
  end

  it 'product.nameが含まれないこと' do
    get category_path(other_parent_taxon.id)
    expect(response.body).not_to include(product.name)
  end

  it 'taxon.nameが含まれないこと' do
    get category_path(other_parent_taxon.id)
    expect(response.body).not_to include(taxon.name)
  end

  it 'other_parent_taxon.nameが含まれること' do
    get category_path(other_parent_taxon.id)
    expect(response.body).to include(other_parent_taxon.name)
  end
end
