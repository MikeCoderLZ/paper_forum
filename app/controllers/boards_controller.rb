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
    
    def edit
        @board = Board.find(params[:id])
    end
    
    def create
        @board = Board.new( board_params )
        
        if @board.save
            redirect_to @board
        else
            render 'new'
        end
    end
    
    def update
        @board = Board.find(params[:id])
        
        if @board.update(board_params)
            redirect_to @board
        else
            render 'edit'
        end
        
    end
    
    def destroy
        swap = Board.find(params[:id])
        @board = Board.find(swap.parent.id)
        swap.destroy
        
        redirect_to @board
    end
    
    private
    def board_params
        params.require(:board).permit(:name, :description, :parent_id )
    end
    
end
