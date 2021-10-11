class BooksController < ApplicationController

  before_action :authenticate_user!,except: [:top]

  def index
    @books = Book.all
    @rank_books = Book.order(impressions_count: 'DESC')
    @book_new = Book.new
    @user = current_user
    @books = Book.includes(:favorited_users).sort {|a,b| b.favorited_users.size <=> a.favorited_users.size}

  end

  def create
    @books = Book.all
    @user = current_user
    @book_new = Book.new(book_params)
    @book_new.user_id = current_user.id
    if @book_new.save
      flash[:notice] = "successfully completed"
      redirect_to book_path(@book_new)
    else
      render :index
    end

  end

  def show
    @book = Book.find(params[:id])
    impressionist(@book, nil, unique: [:ip_address])
    @book_comment = BookComment.new
    @book_comments = @book.book_comments.order(created_at: :desc)
    @books = Book.all
    @user = @book.user
    @book_new = Book.new

  end

  def edit
    @book = Book.find(params[:id])
    if @book.user == current_user
      render :edit
    else
      redirect_to books_path
    end

  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "successfully completed"
      redirect_to book_path(@book.id)
    else
      render("books/edit")
    end

  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path

  end

  private
  def book_params
    params.require(:book).permit(:title, :body)
  end

end
