class ReviewSweeper < ActionController::Caching::Sweeper
  observe Review
  def after_create(review)
    expire_cache_for(review)
  end

  def after_update(review)
    expire_cache_for(review)
  end

  def after_destroy(review)
    expire_cache_for(review)
  end
  
  private
  
  def expire_cache_for(review)
    review.reviewable.recalculate_rating if review.reviewable
  end
end
