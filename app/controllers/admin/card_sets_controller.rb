class Admin::CardSetsController < Admin::AdminController
  authorize_resource

  def index
    if params[:q].present? && params[:q][:s].present?
      @search = CardSet.unscoped.search(params[:q])
    else
      @search = CardSet.search(params[:q])
    end

    @card_sets = @search.result.page(params[:page]).order('card_sets.release_date ASC')
  end

  def show
    @card_set = CardSet.where(:slug => params[:id]).first

    if @card_set.nil?
      redirect_to admin_card_sets_url, :notice => t('messages.card_sets.could_not_find')
    end
  end

  def new
    @card_set = CardSet.new
  end

  def create
    @card_set = CardSet.new(params[:card_set])

    if @card_set.save
      redirect_to admin_card_sets_url, :notice => t('messages.card_sets.created')
    else
      render 'new'
    end
  end

  def edit
    @card_set = CardSet.where(:slug => params[:id]).first

    if @card_set.nil?
      redirect_to admin_card_sets_url, :notice => t('messages.card_sets.could_not_find')
    end
  end

  def update
    @card_set = CardSet.where(:slug => params[:id]).first

    if @card_set.nil?
      redirect_to admin_card_sets_url, :notice => t('messages.card_sets.could_not_find') and return
    end

    if @card_set.update_attributes(params[:card_set])
      redirect_to edit_admin_card_set_url(@card_set), :notice => t('messages.card_sets.updated')
    else
      render 'edit'
    end
  end

  def destroy
    @card_set = CardSet.where(:slug => params[:id]).first

    if @card_set.nil?
      redirect_to admin_card_sets_url, :notice => t('messages.card_sets.could_not_find') and return
    end

    @card_set.destroy

    redirect_to admin_card_sets_url, :notice => t('messages.card_sets.deleted')
  end
end
