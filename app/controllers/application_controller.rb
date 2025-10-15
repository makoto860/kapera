class ApplicationController < ActionController::Base
  CATEGORIES_ROOT_TAXON_NAME = "Categories".freeze

  TAXON_IMAGE_MAP = {
    'Clothing' => 'cloth',
    'Caps' => 'cap',
    'Bags' => 'bag',
    'Mugs' => 'tableware',
  }.freeze

  before_action :load_all_taxons
  include ActiveStorage::SetCurrent

  protect_from_forgery with: :exception

  unless Rails.env.development?
    rescue_from Exception,                      with: :_render_500
    rescue_from ActiveRecord::RecordNotFound,   with: :_render_404
    rescue_from ActionController::RoutingError, with: :_render_404
  end

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  private

  def load_all_taxons
    # "Categories"が存在しない場合は例外を出す。
    root_taxon = Spree::Taxon.find_by!(name: CATEGORIES_ROOT_TAXON_NAME)
    allowed_names = TAXON_IMAGE_MAP.keys
    @taxons = root_taxon.children.where(name: allowed_names)
  end

  def _render_404(e: nil)
    logger.info "Rendering 404 with exception: #{e.message}" if e

    render "errors/404.html", status: :not_found, layout: "error"
  end

  def _render_500(e: nil)
    logger.error "Rendering 500 with exception: #{e.message}" if e

    render "errors/500.html", status: :internal_server_error, layout: "error"
  end
end
