class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]

  # GET /posts
  def index
    limit = params[:count] ? Integer(params[:count]) : 3
    cursor = params[:cursor] ? Integer(params[:cursor]) : 1
    @posts = Post.where("id >= ?", cursor).limit(limit).order(:created_at)
    next_cursor = cursor + limit >= Post.count ? "" : @posts.last.id + 1
    render json: {"posts": @posts,"next_cursor": next_cursor}, status: :ok
  end

  # GET /posts/1
  def show
    render json: @post
  end

  # POST /posts
  def create
    @post = Post.new(post_params)

    if @post.save
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:post).permit(:name, :title, :content)
    end
end
