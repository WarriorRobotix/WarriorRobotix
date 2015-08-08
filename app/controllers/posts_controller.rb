class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_admin!, except: [:index, :show]

  # GET /posts
  # GET /posts.json
  def index
    case params[:type]
    when "Event"
      scope = Event
    else
      scope = Post
    end
    @posts = scope.where("restriction <= ?", max_restriction).order(created_at: :desc).all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    case params[:type]
    when "Event"
      @post = Event.new
    else
      @post = Post.new
    end
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    case params[:type]
    when "Event"
      @post = Event.new(post_params)
    else
      @post = Post.new(post_params)
    end
    @post.author = current_member

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params(type=nil)
    type = type.try(:to_s).try(:capitalize)
    k = type || params[:type] || "Post"
    case (type || params[:type] || "Post")
    when "Event"
      params.require(:event).permit(:title, :description, :start_at, :end_at, :restriction)
    else
      params.require(:post).permit(:title, :description, :restriction)
    end
  end
end
