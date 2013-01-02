class Admin::CardBlocksController < Admin::AdminController
  authorize_resource

  def index
    if params[:q].present? && params[:q][:s].present?
      @search = CardBlock.unscoped.search(params[:q])
    else
      @search = CardBlock.search(params[:q])
    end

    @card_blocks = @search.result.page(params[:page]).order('card_blocks.name ASC')
  end

  def show
    @card_block = CardBlock.where(:slug => params[:id]).first

    if @card_block.nil?
      redirect_to admin_card_blocks_url, :notice => t('messages.card_blocks.could_not_find')
    end
  end

  def new
    @card_block = CardBlock.new
  end

  def create
    @card_block = CardBlock.new(params[:card_block])

    if @card_block.save
      redirect_to admin_card_blocks_url, :notice => t('messages.card_blocks.created')
    else
      render 'new'
    end
  end

  def edit
    @card_block = CardBlock.where(:slug => params[:id]).first

    if @card_block.nil?
      redirect_to admin_card_blocks_url, :notice => t('messages.card_blocks.could_not_find')
    end
  end

  def update
    @card_block = CardBlock.where(:slug => params[:id]).first

    if @card_block.nil?
      redirect_to admin_card_blocks_url, :notice => t('messages.card_blocks.could_not_find') and return
    end

    if @card_block.update_attributes(params[:card_block])
      redirect_to edit_admin_card_block_url(@card_block), :notice => t('messages.card_blocks.updated')
    else
      render 'edit'
    end
  end

  def destroy
    @card_block = CardBlock.where(:slug => params[:id]).first

    if @card_block.nil?
      redirect_to admin_card_blocks_url, :notice => t('messages.card_blocks.could_not_find') and return
    end

    @card_block.destroy

    redirect_to admin_card_blocks_url, :notice => t('messages.card_blocks.deleted')
  end
end
