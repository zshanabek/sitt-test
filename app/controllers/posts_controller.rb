class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]
  DEFAULT_PAGE_SIZE = 3

  # GET /posts
  def index
    limit = params[:page][:size] ? Integer(params[:page][:size]) : DEFAULT_PAGE_SIZE
    direction = params[:page][:after] ? :after : :before
    cursor = params[:page][direction] ? Integer(params[:page][direction]) : 1
    @posts = direction == :after ? Post.where("id >= ?", cursor) : Post.where("id < ?", cursor)
    @posts = @posts.limit(limit).order(:created_at)
    @last_end = Post.where(:id => cursor..Post.last.id)
    @last_beginning = Post.where(:id => Post.first.id..cursor)
    next_cursor = limit < @last_end.count ? @posts.last.id + 1 : ""
    prev_cursor = limit < @last_beginning.count ? @last_beginning.last.id - 1 : ""
    render json: {"posts": @posts,"next_cursor": next_cursor,"prev_cursor": prev_cursor}, status: :ok
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
      params.permit(:title, :content)
    end
end
