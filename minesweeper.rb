require_relative "board"
require_relative "player"

class Minesweeper

    def initialize(size = 9)
        @size = size
        @board = Board.new(size)
        @player = Player.new
    end

    def get_player_input
        pos = nil
        until pos
            pos = @player.get_pos
            pos = nil if !valid_pos?(pos)
        end
        pos
    end

    def valid_pos?(pos)
        ("rf".include?(pos[0])) &&
            pos[1].between?(0,@size-1) &&
            pos[2].between?(0,@size-1)
    end

    def run
        @board.render
        until @board.won? || @board.lose?
            input = get_player_input
            type, x, y = input
            @board.reveal(x,y) if type == "r"
            @board.flag(x,y) if type == "f"
            @board.render
        end
    end

end

if $PROGRAM_NAME == __FILE__
    Game = Minesweeper.new
    Game.run
end