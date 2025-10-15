module ApplicationHelper
  BASE_TITLE = "BIGBAG Store".freeze

  def full_title(page_title)
    if page_title.blank?
      BASE_TITLE
    else
      "#{page_title} - #{BASE_TITLE}"
    end
  end

  def image_name_for_taxon(taxon)
    # ApplicationControllerに定義したTAXON_IMAGE_MAP画像
    ApplicationController::TAXON_IMAGE_MAP[taxon.name]
  end
end
