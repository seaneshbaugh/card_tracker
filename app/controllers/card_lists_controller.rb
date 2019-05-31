# frozen_string_literal: true

class CardListsController < ApplicationController
  before_action :authenticate_user!

  def index
    @search = CardList.ransack(params[:q])
    @card_lists = @search.result.includes(:collections).where(user_id: current_user.id).display_order.page(params[:page])
  end

  def show
    @card_list = find_card_list
    @search = Collection.ransack(params[:q])
    @collections = @search.result.where(collections: { card_list_id: @card_list.id }).quantity_greater_than_zero.display_order.page(params[:page])
    @sets = @collections.group_by { |collection| collection.card.card_set }.sort_by { |card_set, _| card_set.release_date }
  end

  def new
    @card_list = CardList.new
  end

  def create
    @card_list = CardList.new(card_list_params)
    @card_list.user_id = current_user.id
    @card_list.order = current_user.card_lists.count + 1

    if @card_list.save
      flash[:success] = t('.success')

      redirect_to root_url, status: :see_other
    else
      flash.now[:error] = helpers.error_messages_for(@card_list)

      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    @card_list = find_card_list
  end

  def update
    @card_list = find_card_list

    if @card_list.update(card_list_params)
      flash[:success] = t('.success')

      redirect_to edit_list_url(@card_list.slug), status: :see_other
    else
      flash.now[:error] = helpers.error_messages_for(@card_list)

      render 'edit', status: :unprocessable_entity
    end
  end

  def reorder
    respond_to do |format|
      format.json do
        card_lists_order = params.require(:card_lists_order).permit!

        card_list_ids = []

        card_lists_order.each do |id, _|
          card_list_ids << id
        end

        card_lists = CardList.where(id: card_list_ids, user_id: current_user.id)

        begin
          CardList.transaction do
            card_lists.each do |card_list|
              card_list.update!(order: card_lists_order[card_list.id.to_s])
            end
          end
        rescue StandardError => error
          # TODO: Figure out how to better handle errors here.
          render json: { message: t('.failure'), errors: [error.message] }, status: :unprocessable_entity

          return
        end

        render json: { message: t('.success') }, status: :ok
      end
    end
  end

  def destroy
    @card_list = find_card_list

    @card_list.destroy

    flash[:success] = t('.success')

    redirect_to root_url, status: :see_other
  end

  private

  def card_list_params
    params.require(:card_list).permit(:name)
  end

  def find_card_list
    CardList.find_by!(user_id: current_user.id, slug: params[:id])
  end
end
