# frozen_string_literal: true

class CardListsController < ApplicationController
  before_action :authenticate_user!

  def index
    @search = CardList.search(params[:q])

    @card_lists = @search.result.where(user_id: current_user.id).order(order: :asc).page(params[:page])
  end

  def show
    @card_list = find_card_list

    @search = Collection.search(params[:q])

    # TODO: Make this a scope.
    @collections = @search.result.includes(card: { card_set: { card_block: :card_block_type } })
                          .where(collections: { card_list_id: @card_list.id })
                          .where(Collection.arel_table[:quantity].gt(0))
                          .order('"card_block_types"."id", "card_blocks"."id", "card_sets"."release_date" ASC, cast("cards"."card_number" as unsigned) ASC, "cards"."name" ASC')
                          .page(params[:page])

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
        card_list_order = JSON.parse(params[:card_list_order])

        card_lists = CardList.where(id: card_list_order.map { |k, _| k }, user_id: current_user.id)

        begin
          CardList.transaction do
            card_lists.each do |card_list|
              card_list.update!(order: card_list_order[card_list.id.to_s])
            end
          end
        rescue StandardError => e
          render(json: { status: 405, status_message: 'Failed to reorder your lists.', errors: [e.message] }, status: :method_not_allowed) && (return)
        end

        render json: { status: 200, status_message: 'Your lists have been reordered.' }, status: :ok
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
