class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    @book_comment = BookComment.new
  end

  def index
    @book = Book.new
    if params[:sort] == 'newer'
      @books = Book.order(created_at: 'DESC')
    elsif params[:sort] == 'higher'
      @books = Book.order(star: 'DESC')
    else
      @books = Book.all
    end
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path
  end

  def search
    @tag = params[:tag]
    if @tag.present?
      @books = Book.where("tag LIKE?","%#{@tag}%")
    else
      @books = Book.all
    end
    render :search_result
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :tag, :star)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end
end
