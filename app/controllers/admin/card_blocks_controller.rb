# frozen_string_literal: true

module Admin
  class CardBlocksController < AdminController
    def index
      @search = CardBlock.search(params[:q])

      @card_blocks = @search.result.includes(:card_sets).page(params[:page])
    end

    def show
      @card_block = CardBlock.where(id: params[:id]).includes(:card_block_type, :card_sets).first

      if @card_block.nil?
        flash[:error] = t('messages.card_blocks.could_not_find')

        redirect_to admin_card_blocks_url
      end
    end

    def new
      @card_block = CardBlock.new
    end

    def create
      @card_block = CardBlock.new(params[:card_block])

      if @card_block.save
        flash[:success] = t('messages.card_blocks.created')

        redirect_to admin_card_blocks_url
      else
        flash.now[:error] = @card_block.errors.full_messages.uniq.join('. ') + '.'

        render 'new'
      end
    end

    def edit
      @card_block = CardBlock.where(id: params[:id]).first

      if @card_block.nil?
        flash[:error] = t('messages.card_blocks.could_not_find')

        redirect_to admin_card_blocks_url
      end
    end

    def update
      @card_block = CardBlock.where(id: params[:id]).first

      if @card_block.nil?
        flash[:error] = t('messages.card_blocks.could_not_find')

        redirect_to(admin_card_blocks_url) && return
      end

      if @card_block.update(params[:card_block])
        flash[:success] = t('messages.card_blocks.updated')

        redirect_to edit_admin_card_block_url(@card_block)
      else
        flash.now[:error] = @card_block.errors.full_messages.uniq.join('. ') + '.'

        render 'edit'
      end
    end

    def destroy
      @card_block = CardBlock.where(id: params[:id]).first

      if @card_block.nil?
        flash[:error] = t('messages.card_blocks.could_not_find')

        redirect_to(admin_card_blocks_url) && return
      end

      @card_block.destroy

      flash[:success] = t('messages.card_blocks.deleted')

      redirect_to admin_card_blocks_url
    end
  end
end
