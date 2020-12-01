class BooksController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @newbook = Book.new
    @book = Book.find(params[:id])
    @user = @book.user
  end

  def index
    @books = Book.all
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user = current_user
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    if @book.user == current_user
        render "edit"
    else
        redirect_to books_path
    end
  end

  def update
    @book.user = current_user
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path, notice: "successfully delete book!"
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

    def ensure_correct_user
      @book = Book.find(params[:id])
      unless @book.user == current_user
       redirect_to books_path
      end
    end

end
