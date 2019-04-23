# frozen_string_literal: true

class CollectionsController < ApplicationController
  before_action :authenticate_user!

  def update_quantity
    respond_to do |format|
      format.json do
        card_list = CardList.where(id: params[:card_list_id]).first

        render(json: { status: 404, status_message: t('messages.card_lists.could_not_find') }, status: :not_found) && return if card_list.nil?

        card = Card.where(id: params[:card_id]).first

        render(json: { status: 404, status_message: t('messages.cards.could_not_find') }, status: :not_found) && return if card.nil?

        collection = Collection.where(card_list_id: params[:card_list_id], card_id: params[:card_id], user_id: current_user.id).first

        collection = Collection.new(card_list_id: params[:card_list_id], card_id: params[:card_id], user_id: current_user.id) if collection.nil?

        if params[:quantity].present?
          quantity = params[:quantity].to_i

          quantity = 0 if quantity.negative?

          collection.quantity = quantity

          if collection.save
            render json: { status: 200, status_message: 'Your collection has been updated.', new_quantity: collection.quantity }, status: :ok
          else
            render json: { status: 405, status_message: 'Failed to update your collection', errors: collection.errors.full_messages }, status: :method_not_allowed
          end
        else
          render json: { status: 400, status_message: 'Failed to update your collection', errors: ['Quantity cannot be blank'] }, status: :bad_request
        end
      end
    end
  end

  def move_card_list
    respond_to do |format|
      format.json do
        card_list = CardList.where(id: params[:card_list_id]).first

        render(json: { status: 404, status_message: t('messages.card_lists.could_not_find') }, status: :not_found) && return if card_list.nil?

        new_card_list = CardList.where(id: params[:new_card_list_id]).first

        render(json: { status: 404, status_message: t('messages.card_lists.could_not_find') }, status: :not_found) && return if new_card_list.nil?

        card = Card.where(id: params[:card_id]).first

        render(json: { status: 404, status_message: t('messages.cards.could_not_find') }, status: :not_found) && return if card.nil?

        collection = Collection.where(card_list_id: params[:card_list_id], card_id: params[:card_id], user_id: current_user.id).first

        render(json: { status: 404, status_message: t('messages.collections.could_not_find') }, status: :not_found) && return if collection.nil?

        render(json: { status: 400, status_message: 'Quantity cannot be blank.' }, status: :bad_request) && return if params[:quantity].blank?

        quantity = params[:quantity].to_i

        if quantity.negative?
          quantity = 0
        elsif quantity > collection.quantity
          quantity = collection.quantity
        end

        render(json: { status: 400, status_message: 'Quantity cannot be zero.' }, status: :bad_request) && return if quantity.zero?

        new_collection = Collection.where(card_list_id: params[:new_card_list_id], card_id: params[:card_id], user_id: current_user.id).first

        new_collection = Collection.new(card_list_id: params[:new_card_list_id], card_id: params[:card_id], user_id: current_user.id, quantity: 0) if new_collection.nil?

        begin
          Collection.transaction do
            new_collection.save! unless new_collection.persisted?

            collection.update!(quantity: collection.quantity - quantity)

            new_collection.update!(quantity: new_collection.quantity + quantity)
          end
        rescue StandardError => e
          render(json: { status: 405, status_message: 'Failed to move your collection.', errors: [e.message] }, status: :method_not_allowed) && (return)
        end

        render json: { status: 200, status_message: 'Your collection has been moved.', new_quantity: collection.quantity }, status: :ok
      end
    end
  end
end
