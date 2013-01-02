class Admin::CardsController < Admin::AdminController
  authorize_resource

  def index
    if params[:q].present? && params[:q][:s].present?
      @search = Card.unscoped.search(params[:q])
    else
      @search = Card.search(params[:q])
    end

    @cards = @search.result.page(params[:page]).order('cards.multiverse_id ASC')
  end

  def show
    @card = Card.where(:slug => params[:id]).first

    if @card.nil?
      redirect_to admin_cards_url, :notice => t('messages.cards.could_not_find')
    end
  end

  def new
    @card = Card.new
  end

  def create
    @card = Card.new(params[:card])

    if @card.save
      redirect_to admin_cards_url, :notice => t('messages.cards.created')
    else
      render 'new'
    end
  end

  def edit
    @card = Card.where(:slug => params[:id]).first

    if @card.nil?
      redirect_to admin_cards_url, :notice => t('messages.cards.could_not_find')
    end
  end

  def update
    @card = Card.where(:slug => params[:id]).first

    if @card.nil?
      redirect_to admin_cards_url, :notice => t('messages.cards.could_not_find') and return
    end

    if @card.update_attributes(params[:card])
      redirect_to edit_admin_card_url(@card), :notice => t('messages.cards.updated')
    else
      render 'edit'
    end
  end

  def destroy
    @card = Card.where(:slug => params[:id]).first

    if @card.nil?
      redirect_to admin_cards_url, :notice => t('messages.cards.could_not_find') and return
    end

    @card.destroy

    redirect_to admin_cards_url, :notice => t('messages.cards.deleted')
  end
end
