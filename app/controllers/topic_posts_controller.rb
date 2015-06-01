class TopicPostsController < ApplicationController
    
    def index
        # I'm not sure about this; indexing posts is a little weird.
        # I suppose we should select only root posts, because that will
        # implicitly include all posts
        @topic_post = TopicPost.all
    end
    
    def show
        # We need pagination logic here; a post is nothing without its context
        # Hopefully the pagination gem we added can help.
        @topic_post = TopicPost.find(params[:ed])
    end
    
    def new
        @topic_post = TopicPost.new
        # now we resolve if we are commenting on a topic or starting one
    end
    
    def edit
        @topic_post = TopicPost.find(params[:id])
    end
    
    def create
        @topic_post = TopicPost.new( topic_post_params )
        
        if @topic_post.save
            redirect_to @topic_post
        else
            render 'new'
        end
    end
    
    def update
        @topic_post = TopicPost.find(params[:id])
        
        if @topic_post.update( topic_post_params )
            redirect_to @topic_post
        else
            render 'edit'
        end
        
    end
    
    def destroy
        # the logic here will be different: if we deleted a comment on a topic,
        # then redirect to the appropriate page of the topic. Otherwise,
        # redirect to the containing board. Again , pagination logic.
    end
    
    private
        def topic_post_params
            params.require(:content, :user, :board, :root_post, :is_topic_post)
        end
    
end
