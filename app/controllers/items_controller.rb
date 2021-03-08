class ItemsController < ApplicationController
  before_action :set_task, only: %i[show update]
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @items = policy_scope(Item).order(:start_date)
    @review = Review.new
    unless params[:item] == nil
      @selected = Item.find(params[:item])
    end
  end

  def show
    @review = Review.new
    @item.last_opened = DateTime.now
    @item.save
  end

  def new
    @item = Item.new
    # authorize @item if current_user.owner
  end

  def create
    @item = Item.create(item_params)
    @item.user = current_user
    authorize @item
    if @item.save
      @item.last_opened = DateTime.now
      @item.save
      redirect_to users_show_path
    else
      render :new
    end
  end

  private

  def item_params
    params.require(:item).permit(:title, :start_date, :category, :details, :end_date, :recurring, :completed,
                                 :editable, :deletable, :photo)
  end

  def set_task
    @item = Item.find(params[:id])
    authorize @item
  end
end
