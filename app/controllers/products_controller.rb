class ProductsController < ApplicationController
  def show
    # 1つだけ存在する画像を取得する
    @product = Spree::Product.joins(master: :images).find(params[:id])
    @taxon = @product.taxons.first
    @categories = @taxon.self_and_ancestors.where.not(parent_id: nil)
  end
end
