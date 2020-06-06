class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]

  # GET /posts
  def index
    limit = Integer(params[:count]) + 1
    if params[:cursor]
      cursor = Integer(params[:cursor])
      @posts = Post.where("id >= ?", cursor).limit(limit)
      if cursor + limit >= Post.count
        next_cursor = ""
      else
        next_cursor = @posts.last.id + 1
      end
      render json: {"posts": @posts,"next_cursor": next_cursor}, status: :ok
    else
      if limit >= Post.count
        next_cursor = ""
      else
        next_cursor = @posts.last.id + 1
      end
      @posts = Post.limit(limit)
      render json: {"posts": @posts,"next_cursor": @posts.last.id+1}, status: :ok
    end
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
