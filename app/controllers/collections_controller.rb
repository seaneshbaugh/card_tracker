# frozen_string_literal: true

class CollectionsController < ApplicationController
  before_action :authenticate_user!

  respond_to :json

  def update_quantity
    card_list = find_card_list
    card = find_card
    collection = find_collection

    if collection.update(collection_params)
      render json: { message: t('.success'), new_quantity: collection.quantity }, status: :ok
    else
      render json: { message: t('.failure'), errors: collection.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def move_card_list
    card_list = find_card_list
    new_card_list = find_new_card_list
    card = find_card
    collection = find_collection
    new_collection = find_new_collection
    quantity = params[:quantity].to_i.clamp(0, collection.quantity)

    begin
      Collection.transaction do
        new_collection.save! unless new_collection.persisted?

        collection.update!(quantity: collection.quantity - quantity)

        new_collection.update!(quantity: new_collection.quantity + quantity)
      end
    rescue StandardError => error
      # TODO: Figure out how to better handle errors here.
      render json: { message: t('.failure'), errors: [error.message] }, status: :unprocessable_entity
    end

    render json: { message: t('.success'), new_quantity: collection.quantity }, status: :ok
  end

  private

  def collection_params
    params.permit(:quantity)
  end

  def find_card
    Card.find_by!(id: params[:card_id])
  end

  def find_card_list
    CardList.find_by!(id: params[:card_list_id])
  end

  def find_collection
    Collection.find_or_initialize_by(card_list_id: params[:card_list_id], card_id: params[:card_id], user_id: current_user.id)
  end

  def find_new_card_list
    CardList.find_by!(id: params[:new_card_list_id])
  end

  def find_new_collection
    Collection.find_or_initialize_by(card_list_id: params[:new_card_list_id], card_id: params[:card_id], user_id: current_user.id)
  end
end
