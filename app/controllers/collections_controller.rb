class CollectionsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @search = Collection.search(params[:q])

    @collections = @search.result.includes(:card => { :card_set => { :card_block => :card_block_type } }).where(:user_id => current_user.id).where('`collections`.`quantity` > ?', 0).order('`card_block_types`.`id`, `card_blocks`.`id`, `card_sets`.`release_date` ASC, cast(`cards`.`card_number` as unsigned) ASC, `cards`.`name` ASC').page(params[:page])

    @sets = @collections.group_by { |collection| collection.card.card_set }.sort_by { |card_set, collections| card_set.release_date }
  end

  def update
    respond_to do |format|
      format.json do
        @card = Card.where(:id => params[:card_id]).first

        if @card.blank?
          render :json => { :status => 404, :status_message => t('messages.cards.could_not_find') }, :status => 404 and return
        end

        @collection = Collection.where(:card_id => params[:card_id], :user_id => current_user.id).first

        if @collection.nil?
          @collection = Collection.new(:card_id => params[:card_id], :user_id => current_user.id)
        end

        if params[:quantity].present?
          quantity = params[:quantity].to_i

          if quantity < 0
            quantity = 0
          end

          @collection.quantity = quantity
        else
          @collection.quantity = 0
        end

        if @collection.save
          render :json => { :status => 200, :status_message => 'Your collection has been updated.', :new_quantity => @collection.quantity }, :status => 200 and return
        else
          render :json => { :status => 405, :status_message => 'Failed to update your collection', :errors => @collection.errors.full_messages }, :status => 405 and return
        end
      end
    end
  end
end
