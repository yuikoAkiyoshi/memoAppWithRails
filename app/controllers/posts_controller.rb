class PostsController < ApplicationController
    before_action :authenticate_user
    
    def index
        @posts = Post.all.order(created_at: :desc)
    end

    def new
        @post = Post.new
    end
       
    def create
        @post = Post.new(title: params[:title], body: params[:body], name: params[:name], image_name: [])
        if params[:image]
            @post.image_name = "#{@post.id}.jpg"
            image = params[:image]
            File.binwrite("public/post_images/#{@post.image_name}", image.read)
        end
        if @post.save
            flash[:notice] = "投稿を作成しました"
            redirect_to("/posts/index")
        else
            render("posts/new")
        end
    end

    def show
        @post = Post.find_by(id: params[:id])
    end

    def edit
        @post = Post.find_by(id: params[:id])
    end

    def update
        @post = Post.find_by(id: params[:id])
        @post.title = params[:title]
        @post.body = params[:body]
        @post.name = params[:name]
        if @post.save
            redirect_to("/posts/index")
        else
            render("posts/:id/edit")
        end
    end

    def destroy
        @post = Post.find_by(id: params[:id])
        @post.destroy
        redirect_to("/posts/index")
    end
end