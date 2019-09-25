# frozen_string_literal: true

module Admin
  class CardSetsController < AdminController
    def index
      @search = CardSet.search(params[:q])

      @card_sets = @search.result.includes(card_block: :card_block_type).order('`card_block_types`.`id`, `card_blocks`.`id`, `card_sets`.`release_date` ASC').page(params[:page])
    end

    def show
      @card_set = CardSet.where(id: params[:id]).first

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
      @card_set = CardSet.where(id: params[:id]).first

      if @card_set.nil?
        flash[:error] = t('messages.card_sets.could_not_find')

        redirect_to admin_card_sets_url
      end
    end

    def update
      @card_set = CardSet.where(id: params[:id]).first

      if @card_set.nil?
        flash[:error] = t('messages.card_sets.could_not_find')

        redirect_to(admin_card_sets_url) && return
      end

      if @card_set.update(params[:card_set])
        flash[:success] = t('messages.card_sets.updated')

        redirect_to edit_admin_card_set_url(@card_set)
      else
        flash.now[:error] = @card_set.errors.full_messages.uniq.join('. ') + '.'

        render 'edit'
      end
    end

    def destroy
      @card_set = CardSet.where(id: params[:id]).first

      if @card_set.nil?
        flash[:error] = t('messages.card_sets.could_not_find')

        redirect_to(admin_card_sets_url) && return
      end

      @card_set.destroy

      flash[:success] = t('messages.card_sets.deleted')

      redirect_to admin_card_sets_url
    end
  end
end
