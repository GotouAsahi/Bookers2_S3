class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: %i[edit update]
  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    @group.users << current_user
    if @group.save
      redirect_to groups_path
    else
      render :new
    end
  end

  def index
    @book = Book.new
    @groups = Group.all
  end

  def show
    @book = Book.new
    @group = Group.find(params[:id])
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path
    else
      render :edit
    end
  end

  def join
    @group = Group.find(params[:group_id])
    @group.users << current_user
    redirect_to  groups_path
  end

  def exit
    @group = Group.find(params[:group_id])
    @group.users.delete(current_user)
    redirect_to groups_path
  end

  def new_mail
    @notice = Notice.new
    @group = Group.find(params[:group_id])
  end

  def send_mail
    @notice = Notice.new(notice_params)
    @group = Group.find(params[:group_id])
    @notice.group_id = @group.id
    if @notice.save
      @group.users.each do |group_user|
        user = User.find(group_user.id)
        ContactMailer.send_when_owner_announce(user, @group, @notice).deliver
      end
      redirect_to group_mail_notice_path(@group.id, @notice.id)
    else
      render :new
    end
  end

  def send_mail_notice
    @notice = Notice.find(params[:id])
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction, :image)
  end

  def notice_params
    params.require(:notice).permit(:title,:body)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    redirect_to groups_path unless @group.owner_id == current_user.id
  end
end
