class Admin::CardSetsController < Admin::AdminController
  authorize_resource

  def index
    @search = CardSet.search(params[:q])

    @card_sets = @search.result.order('card_sets.created_at ASC').page(params[:page])
  end

  def show
    @card_set = CardSet.where(:id => params[:id]).first

    if @card_set.nil?
      flash[:error] = t('messages.card_sets.could_not_find')

      redirect_to admin_card_sets_url
    end
  end

  def new
    @card_set = CardSet.new
  end

  def create
    @card_set = CardSet.new(params[:card_set])

    if @card_set.save
      flash[:success] = t('messages.card_sets.created')

      redirect_to admin_card_sets_url
    else
      flash.now[:error] = @card_set.errors.full_messages.uniq.join('. ') + '.'

      render 'new'
    end
  end

  def edit
    @card_set = CardSet.where(:id => params[:id]).first

    if @card_set.nil?
      flash[:error] = t('messages.card_sets.could_not_find')

      redirect_to admin_card_sets_url
    end
  end

  def update
    @card_set = CardSet.where(:id => params[:id]).first

    if @card_set.nil?
      flash[:error] = t('messages.card_sets.could_not_find')

      redirect_to admin_card_sets_url and return
    end

    if @card_set.update_attributes(params[:card_set])
      flash[:success] = t('messages.card_sets.updated')

      redirect_to edit_admin_card_set_url(@card_set)
    else
      flash.now[:error] = @card_set.errors.full_messages.uniq.join('. ') + '.'

      render 'edit'
    end
  end

  def destroy
    @card_set = CardSet.where(:id => params[:id]).first

    if @card_set.nil?
      flash[:error] = t('messages.card_sets.could_not_find')

      redirect_to admin_card_sets_url and return
    end

    @card_set.destroy

    flash[:success] = t('messages.card_sets.deleted')

    redirect_to admin_card_sets_url
  end
end
