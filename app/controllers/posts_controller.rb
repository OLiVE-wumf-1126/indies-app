class PostsController < ApplicationController
  before_action :artist_action, only: %i[new create edit update destroy]
  before_action :listener_action, only: [:favoritesindex]

  def index
    @posts = Post.includes(:artist).order('created_at DESC').page(params[:page]).per(9)
    @artists = Artist.limit(10).order(' created_at DESC ')
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.includes(:listener)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to root_path
  end

  def favoritesindex
    @favorites = current_listener.favorite_posts.order('created_at DESC').page(params[:page]).per(9)
  end

  def search; end

  private

  def post_params
    params.require(:post).permit(:youtube_url, :text, :title, :tag_list).merge(artist_id: current_artist.id)
  end

  def artist_action
    redirect_to root_path unless artist_signed_in?
  end

  def listener_action
    redirect_to root_path unless listener_signed_in?
  end
end
