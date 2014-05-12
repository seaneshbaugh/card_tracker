class CollectionsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @search = Collection.search(params[:q])

    @collections = @search.result.includes(:card => { :card_set => { :card_block => :card_block_type } }).where(:user_id => current_user.id).where('`collections`.`quantity` > ?', 0).order('`card_block_types`.`id`, `card_blocks`.`id`, `card_sets`.`release_date` ASC, cast(`cards`.`card_number` as unsigned) ASC, `cards`.`name` ASC').page(params[:page])

    @sets = @collections.group_by { |collection| collection.card.card_set }.sort_by { |card_set, _| card_set.release_date }
  end

  def update_quantity
    respond_to do |format|
      format.json do
        card_list = CardList.where(:id => params[:card_list_id]).first

        if card_list.nil?
          render :json => { :status => 404, :status_message => t('messages.card_lists.could_not_find') }, :status => 404 and return
        end

        card = Card.where(:id => params[:card_id]).first

        if card.nil?
          render :json => { :status => 404, :status_message => t('messages.cards.could_not_find') }, :status => 404 and return
        end

        collection = Collection.where(:card_list_id => params[:card_list_id], :card_id => params[:card_id], :user_id => current_user.id).first

        if collection.nil?
          collection = Collection.new(:card_list_id => params[:card_list_id], :card_id => params[:card_id], :user_id => current_user.id)
        end

        if params[:quantity].present?
          quantity = params[:quantity].to_i

          if quantity < 0
            quantity = 0
          end

          collection.quantity = quantity

          if collection.save
            render :json => { :status => 200, :status_message => 'Your collection has been updated.', :new_quantity => collection.quantity }, :status => 200
          else
            render :json => { :status => 405, :status_message => 'Failed to update your collection', :errors => collection.errors.full_messages }, :status => 405
          end
        else
          render :json => { :status => 400, :status_message => 'Failed to update your collection', :errors => ['Quantity cannot be blank'] }, :status => 400
        end
      end
    end
  end

  def move_card_list
    respond_to do |format|
      format.json do
        card_list = CardList.where(:id => params[:card_list_id]).first

        if card_list.nil?
          render :json => { :status => 404, :status_message => t('messages.card_lists.could_not_find') }, :status => 404 and return
        end

        new_card_list = CardList.where(:id => params[:new_card_list_id]).first

        if new_card_list.nil?
          render :json => { :status => 404, :status_message => t('messages.card_lists.could_not_find') }, :status => 404 and return
        end

        card = Card.where(:id => params[:card_id]).first

        if card.nil?
          render :json => { :status => 404, :status_message => t('messages.cards.could_not_find') }, :status => 404 and return
        end

        collection = Collection.where(:card_list_id => params[:card_list_id], :card_id => params[:card_id], :user_id => current_user.id).first

        if collection.nil?
          render :json => { :status => 404, :status_message => t('messages.collections.could_not_find') }, :status => 404 and return
        end

        unless params[:quantity].present?
          render :json => { :status => 400, :status_message => 'Quantity cannot be blank.' }, :status => 400 and return
        end

        quantity = params[:quantity].to_i

        if quantity < 0
          quantity = 0
        elsif quantity > collection.quantity
          quantity = collection.quantity
        end

        if quantity == 0
          render :json => { :status => 400, :status_message => 'Quantity cannot be zero.' }, :status => 400 and return
        end

        new_collection = Collection.where(:card_list_id => params[:new_card_list_id], :card_id => params[:card_id], :user_id => current_user.id).first

        if new_collection.nil?
          new_collection = Collection.new(:card_list_id => params[:new_card_list_id], :card_id => params[:card_id], :user_id => current_user.id, :quantity => 0)
        end

        begin
          Collection.transaction do
            unless new_collection.persisted?
              new_collection.save!
            end

            collection.update_attributes!(:quantity => collection.quantity - quantity)

            new_collection.update_attributes!(:quantity => new_collection.quantity + quantity)
          end
        rescue => e
          render :json => { :status => 405, :status_message => 'Failed to move your collection.', :errors => [e.message] }, :status => 405 and return
        end

        render :json => { :status => 200, :status_message => 'Your collection has been moved.', :new_quantity => collection.quantity }, :status => 200
      end
    end
  end
end
