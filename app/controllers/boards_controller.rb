class BoardsController < ApplicationController
    
    # The index page is identical to the show page, except it
    # always displays the root board "Main"
    def index
        @board = Board.find( 1 )
    end
    # Shows the given board, it's subboards, etc.
    def show
        @board = Board.find(params[:id])
    end
    # Creates a new board under the given parent board.
    # the parent board's ID is given in a hidden field
    def new
        @board = Board.new
        @parent_id = params[:parent_id]
    end
    
    # Similar to the create board page
    def edit
        @board = Board.find(params[:id])
    end
    
    # Errors redirect to the new page
    def create
        @board = Board.new( board_params )
        
        if @board.save
            redirect_to @board
        else
            render 'new'
        end
    end
    # Errors in the form redirect to the edit page
    def update
        @board = Board.find(params[:id])
        
        if @board.update(board_params)
            redirect_to @board
        else
            render 'edit'
        end
        
    end
    # After deletion, serves up parent board
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
