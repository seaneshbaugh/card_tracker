class Admin::CardBlockTypesController < Admin::AdminController
  authorize_resource

  def index
    if params[:q].present? && params[:q][:s].present?
      @search = CardBlockType.unscoped.search(params[:q])
    else
      @search = CardBlockType.search(params[:q])
    end

    @card_block_types = @search.result.page(params[:page]).order('card_block_types.name ASC')
  end

  def show
    @card_block_type = CardBlockType.where(:slug => params[:id]).first

    if @card_block_type.nil?
      redirect_to admin_card_block_types_url, :notice => t('messages.card_block_types.could_not_find')
    end
  end

  def new
    @card_block_type = CardBlockType.new
  end

  def create
    @card_block_type = CardBlockType.new(params[:card_block_type])

    if @card_block_type.save
      redirect_to admin_card_block_types_url, :notice => t('messages.card_block_types.created')
    else
      render 'new'
    end
  end

  def edit
    @card_block_type = CardBlockType.where(:slug => params[:id]).first

    if @card_block_type.nil?
      redirect_to admin_card_block_types_url, :notice => t('messages.card_block_types.could_not_find')
    end
  end

  def update
    @card_block_type = CardBlockType.where(:slug => params[:id]).first

    if @card_block_type.nil?
      redirect_to admin_card_block_types_url, :notice => t('messages.card_block_types.could_not_find') and return
    end

    if @card_block_type.update_attributes(params[:card_block_type])
      redirect_to edit_admin_card_block_type_url(@card_block_type), :notice => t('messages.card_block_types.updated')
    else
      render 'edit'
    end
  end

  def destroy
    @card_block_type = CardBlockType.where(:slug => params[:id]).first

    if @card_block_type.nil?
      redirect_to admin_card_block_types_url, :notice => t('messages.card_block_types.could_not_find') and return
    end

    @card_block_type.destroy

    redirect_to admin_card_block_types_url, :notice => t('messages.card_block_types.deleted')
  end
end
