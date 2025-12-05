class ProductsController < ApplicationController
  RELATED_PRODUCTS_LIMIT = 4

  def show
    @product = Spree::Product.includes(master: [:images]).find(params[:id])
    @related_products = @product.related_products.
      includes(master: [:images, :prices]).
      limit(RELATED_PRODUCTS_LIMIT)
    @taxon = @product.taxons.first
    @categories = @taxon.self_and_ancestors.where.not(parent_id: nil)
  end
end
