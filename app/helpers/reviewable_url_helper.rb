module ReviewableUrlHelper
  include ApplicationHelper

  def reviewable_url(reviewable)
    case reviewable.class.name
      when 'Taxon'
        if reviewable.respond_to?(:brand?) && reviewable.brand?
          seo_url(reviewable)
        else
          nested_taxons_url(reviewable.permalink)
        end
      when 'Product'
      	"/id/#{reviewable.id}"
      else
        polymorphic_url(reviewable)
    end
  end
end