class BoardsController < ApplicationController
    
    def index
        @board = Board.find( 1 )
        @subboards = Board.where( parent: 1 )
    end
    
    def show
        @board = Board.find(params[:id])
        @subboards = Board.where( parent: @board.id )
    end
    
end
