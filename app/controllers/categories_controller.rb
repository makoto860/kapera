class CategoriesController < ApplicationController
  def show
    @taxon = Spree::Taxon.find(params[:id])
    @categories = @taxon.self_and_ancestors.where.not(parent_id: nil)
    # 画像のあるproductのみを取得する
    @products = @taxon.all_products.joins(master: :images).includes(:variant_images, master: :default_price).distinct
  end
end
