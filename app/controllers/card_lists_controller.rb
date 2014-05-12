class CardListsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @search = CardList.search(params[:q])

    @card_lists = @search.result.where(:user_id => current_user.id).order('`card_lists`.`order` ASC').page(params[:page])
  end

  def show
    @card_list = CardList.where(:user_id => current_user.id, :slug => params[:id]).first

    if @card_list.nil?
      flash[:error] = t('messages.card_lists.could_not_find')

      redirect_to root_url and return
    end

    @search = Collection.search(params[:q])

    @collections = @search.result.includes(:card => { :card_set => { :card_block => :card_block_type } }).where('`collections`.`card_list_id` = ? AND `collections`.`quantity` > ?', @card_list.id, 0).order('`card_block_types`.`id`, `card_blocks`.`id`, `card_sets`.`release_date` ASC, cast(`cards`.`card_number` as unsigned) ASC, `cards`.`name` ASC').page(params[:page])

    @sets = @collections.group_by { |collection| collection.card.card_set }.sort_by { |card_set, _| card_set.release_date }
  end

  def new
    @card_list = CardList.new
  end

  def create
    @card_list = CardList.new(params[:card_list])

    @card_list.user_id = current_user.id

    @card_list.order = current_user.card_lists.count + 1

    if @card_list.save
      flash[:success] = t('messages.card_lists.created')

      redirect_to root_url
    else
      flash.now[:error] = @card_list.errors.full_messages.uniq.join('. ') + '.'

      render 'new'
    end
  end

  def edit
    @card_list = CardList.where(:user_id => current_user.id, :slug => params[:id]).first

    if @card_list.nil?
      flash[:error] = t('messages.card_lists.could_not_find')

      redirect_to root_url
    end
  end

  def update
    @card_list = CardList.where(:user_id => current_user.id, :slug => params[:id]).first

    if @card_list.nil?
      flash[:error] = t('messages.card_lists.could_not_find')

      redirect_to root_url and return
    end

    if @card_list.update_attributes(params[:card_list])
      flash[:success] = t('messages.card_lists.updated')

      redirect_to edit_list_url(@card_list.slug)
    else
      flash.now[:error] = @card_list.errors.full_messages.uniq.join('. ') + '.'

      render 'edit'
    end
  end

  def reorder
    respond_to do |format|
      format.json do
        card_list_order = JSON.parse(params[:card_list_order])

        card_lists = CardList.where(:id => card_list_order.map { |k, _| k }, :user_id => current_user.id)

        begin
          CardList.transaction do
            card_lists.each do |card_list|
              card_list.update_attributes!(:order => card_list_order[card_list.id.to_s])
            end
          end
        rescue => e
          render :json => { :status => 405, :status_message => 'Failed to reorder your lists.', :errors => [e.message] }, :status => 405 and return
        end

        render :json => { :status => 200, :status_message => 'Your lists have been reordered.' }, :status => 200
      end
    end
  end

  def destroy
    @card_list = CardList.where(:user_id => current_user.id, :slug => params[:id]).first

    if @card_list.nil?
      flash[:error] = t('messages.card_lists.could_not_find')

      redirect_to root_url and return
    end

    @card_list.destroy

    flash[:success] = t('messages.card_lists.deleted')

    redirect_to root_url
  end
end
