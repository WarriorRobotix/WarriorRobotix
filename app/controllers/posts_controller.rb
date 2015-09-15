class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  skip_before_action :authenticate_admin!, only: [:index, :show]

  # GET /posts
  # GET /posts.json
  def index
    case params[:type]
    when "Event"
      scope = Event
    when "Poll"
      scope = Poll
    else
      scope = Post
    end
    @posts = scope.where("restriction <= ?", max_restriction).order(created_at: :desc).all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    if @post[:restriction] > max_restriction
      if member_signed_in?
        raise Forbidden
      else
        redirect_to signin_path(return_to_info)
      end
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post=  Post.new(post_params)
    @post.author = current_member

    respond_to do |format|
      if @post.save
        if @post.email_notification
          PostMailer.post_email(@post, true).deliver_later
        end
        format.html { try_redirect_back { redirect_to @post, notice: 'Post was successfully created.' } }
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
        if @post.email_notification
          PostMailer.post_email(@post, false).deliver_later
        end
        format.html { try_redirect_back { redirect_to @post, notice: 'Post was successfully updated.' } }
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
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :description, :restriction, :email_notification)
  end
end
