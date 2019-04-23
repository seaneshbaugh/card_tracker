# frozen_string_literal: true

module Admin
  class CardBlockTypesController < AdminController
    authorize_resource

    def index
      @search = CardBlockType.search(params[:q])

      @card_block_types = @search.result.order('`card_block_types`.`name` ASC').page(params[:page])
    end

    def show
      @card_block_type = CardBlockType.where(id: params[:id]).first

      if @card_block_type.nil?
        flash[:error] = t('messages.card_block_types.could_not_find')

        redirect_to admin_card_block_types_url
      end
    end

    def new
      @card_block_type = CardBlockType.new
    end

    def create
      @card_block_type = CardBlockType.new(params[:card_block_type])

      if @card_block_type.save
        flash[:success] = t('messages.card_block_types.created')

        redirect_to admin_card_block_types_url
      else
        flash.now[:error] = @card_block_type.errors.full_messages.uniq.join('. ') + '.'

        render 'new'
      end
    end

    def edit
      @card_block_type = CardBlockType.where(id: params[:id]).first

      if @card_block_type.nil?
        flash[:error] = t('messages.card_block_types.could_not_find')

        redirect_to admin_card_block_types_url
      end
    end

    def update
      @card_block_type = CardBlockType.where(id: params[:id]).first

      if @card_block_type.nil?
        flash[:error] = t('messages.card_block_types.could_not_find')

        redirect_to(admin_card_block_types_url) && return
      end

      if @card_block_type.update(params[:card_block_type])
        flash[:success] = t('messages.card_block_types.updated')

        redirect_to edit_admin_card_block_type_url(@card_block_type)
      else
        flash.now[:error] = @card_block_type.errors.full_messages.uniq.join('. ') + '.'

        render 'edit'
      end
    end

    def destroy
      @card_block_type = CardBlockType.where(id: params[:id]).first

      if @card_block_type.nil?
        flash[:error] = t('messages.card_block_types.could_not_find')

        redirect_to(admin_card_block_types_url) && return
      end

      @card_block_type.destroy

      flash[:success] = t('messages.card_block_types.deleted')

      redirect_to admin_card_block_types_url
    end
  end
end
