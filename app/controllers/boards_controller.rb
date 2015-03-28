class BoardsController < ApplicationController
    
    def index
        @board = Board.find( 1 )
        @subboards = Board.where( parent: 1 )
    end
    
    def show
        @board = Board.find(params[:id])
        @subboards = Board.where( parent: @board.id )
    end
    
    def new
        @board = Board.new
        @parent_id = params[:parent_id]
    end
    
    def create
        @board = Board.new( board_params )
        
        if @board.save
            redirect_to @board
        else
            render 'new'
        end
    end
    
    private
    def board_params
        params.require(:board).permit(:name, :description, :parent_id )
    end
    
end
