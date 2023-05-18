class FavoritesController < ApplicationController
  def create
    return unless Favorite.find_by(book_id: params[:book_id], user_id: current_user.id).blank?

    @book = Book.find(params[:book_id])
    @favorite = current_user.favorites.new(book_id: @book.id)
    @favorite.save
    render 'replace_btn.js.erb'
  end

  def destroy
    return if Favorite.find_by(book_id: params[:book_id], user_id: current_user.id).blank?

    @book = Book.find(params[:book_id])
    @favorite = current_user.favorites.find_by(book_id: @book.id)
    @favorite.destroy
    render 'replace_btn.js.erb'
  end
end
