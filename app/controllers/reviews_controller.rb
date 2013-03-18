class ReviewsController < Spree::BaseController
  helper Spree::BaseHelper
  before_filter :load_product, :only => [:index, :new, :create]
  rescue_from ActiveRecord::RecordNotFound, NoMethodError, :with => :render_404

  def index
    @approved_reviews = Review.approved.where(:product_id => @reviewable.id)
  end

  def new
    @review = Review.new(:reviewable => @reviewable)
    authorize! :new, @review
  end

  # save if all ok
  def create
    params[:review][:rating].sub!(/\s*stars/, '') unless params[:review][:rating].blank?

    @review = Review.new(params[:review])
    @review.reviewable = @reviewable
    @review.user = current_user if user_signed_in?
    @review.ip_address = request.remote_ip

    authorize! :create, @review

    if @review.save
      flash[:message] = t('review_successfully_submitted')
      redirect_to reviewable_url(@reviewable)
    else
      render :action => "new"
    end
  end

  def terms
  end

  private

  include ReviewableUrlHelper

  def load_product
    if params[:taxon_permalink].present?
      @reviewable = Taxon.find_by_permalink!(params[:taxon_permalink])
    elsif params[:product_id].present?
      @reviewable = Product.find_by_permalink!(params[:product_id])
    end
  end

end
