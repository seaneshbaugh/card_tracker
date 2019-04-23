# frozen_string_literal: true

module Admin
  class CardsController < AdminController
    authorize_resource

    def index
      @search = Card.search(params[:q])

      @cards = @search.result.order('`card_block_types`.`id`, `card_blocks`.`id`, `card_sets`.`release_date` ASC, cast(`cards`.`card_number` as unsigned) ASC, `cards`.`name` ASC').includes(card_set: { card_block: :card_block_type }).page(params[:page])
    end

    def show
      @card = Card.where(id: params[:id]).first

      if @card.nil?
        flash[:error] = t('messages.cards.could_not_find')

        redirect_to admin_cards_url
      end
    end

    def new
      @card = Card.new
    end

    def create
      @card = Card.new(params[:card])

      if @card.save
        flash[:success] = t('messages.cards.created')

        redirect_to admin_cards_url
      else
        flash.now[:error] = @card.errors.full_messages.uniq.join('. ') + '.'

        render 'new'
      end
    end

    def edit
      @card = Card.where(id: params[:id]).first

      if @card.nil?
        flash[:error] = t('messages.cards.could_not_find')

        redirect_to admin_cards_url
      end
    end

    def update
      @card = Card.where(id: params[:id]).first

      if @card.nil?
        flash[:error] = t('messages.cards.could_not_find')

        redirect_to(admin_cards_url) && return
      end

      if @card.update(params[:card])
        flash[:success] = t('messages.cards.updated')

        redirect_to edit_admin_card_url(@card)
      else
        flash.now[:error] = @card.errors.full_messages.uniq.join('. ') + '.'

        render 'edit'
      end
    end

    def destroy
      @card = Card.where(id: params[:id]).first

      if @card.nil?
        flash[:error] = t('messages.cards.could_not_find')

        redirect_to(admin_cards_url) && return
      end

      @card.destroy

      flash[:success] = t('messages.cards.deleted')

      redirect_to admin_cards_url
    end
  end
end
