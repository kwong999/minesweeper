require "byebug"

require_relative "tile"

class Board

    attr_reader :board
    def self.creat_board(size)
        map = Array.new(size) {Array.new(size)}
        
        mine_map = (Array.new(size**2 - 10, 0) + Array.new(10, 1)).shuffle #need to set shuffle to finalize, current testing
        mine_map.each.with_index do |value, idx|
            map[idx/size][idx%size] = Tile.new(value == 1, Board.neighbor_bomb_count(mine_map, size, idx))
        end
        map
    end

    def self.neighbor_bomb_count(mine_map, size, idx)
        count = 0
        count += self.check_bombed_N?(mine_map, size, idx)
        count += self.check_bombed_E?(mine_map, size, idx)
        count += self.check_bombed_S?(mine_map, size, idx)
        count += self.check_bombed_W?(mine_map, size, idx)
        count += self.check_bombed_NE?(mine_map, size, idx)
        count += self.check_bombed_NW?(mine_map, size, idx)
        count += self.check_bombed_SE?(mine_map, size, idx)
        count += self.check_bombed_SW?(mine_map, size, idx)
        count
    end
        
    def self.check_bombed_N?(mine_map, size, idx)
        return 0 if idx/size == 0
        mine_map[idx - size]
    end
    def self.check_bombed_E?(mine_map, size, idx)
        return 0 if idx%size == size - 1
        mine_map[idx + 1]
    end
    def self.check_bombed_S?(mine_map, size, idx)
        return 0 if idx/size == size - 1
        mine_map[idx + size] 
    end
    def self.check_bombed_W?(mine_map, size, idx)
        return 0 if idx%size == 0
        mine_map[idx - 1]
    end

    def self.check_bombed_NE?(mine_map, size, idx)
        return 0 if idx/size == 0 || idx%size == size - 1
        mine_map[idx - size + 1]
    end
    def self.check_bombed_NW?(mine_map, size, idx)
        return 0 if idx/size == 0 || idx%size == 0
        mine_map[idx - size - 1]
    end
    def self.check_bombed_SE?(mine_map, size, idx)
        return 0 if idx/size == size - 1 || idx%size == size - 1
        mine_map[idx + size + 1]
    end
    def self.check_bombed_SW?(mine_map, size, idx)
        return 0 if idx/size == size - 1 || idx%size == 0
        mine_map[idx + size - 1]
    end

    def initialize(size = 9)
        @size = size
        @board = Board.creat_board(size)
        @lose = false
    end

    def [](pos)
        x, y = pos
        @board[x][y]
    end

    def reveal(x, y, initial = true)
        if initial == true
            return @lose = true if @board[x][y].bombed?
            return puts "Tile flagged, Please unflag before reveal." if @board[x][y].flagged?
            return puts "Tile revealed already." if @board[x][y].revealed?
        end
        bomb_count = @board[x][y].neighbor_bomb_count
        if @board[x][y].neighbor_bomb_count == 0 && !@board[x][y].bombed? && !@board[x][y].revealed?
            @board[x][y].reveal
            reveal(x-1, y, false) if x != 0
            reveal(x, y+1, false) if y != @size - 1
            reveal(x+1, y, false) if x != @size - 1
            reveal(x, y-1, false) if y != 0
        elsif !@board[x][y].bombed?
            @board[x][y].reveal
        end
    end

    def flag(x, y)
        @board[x][y].flagged? ? (puts "Unflaged.") : (puts "flagged.")
        @board[x][y].flag
    end

    def render
        puts "  #{(0...@size).to_a.join(" ")}"
        @board.each.with_index do |row,idx|
            puts "#{idx} #{row.join(" ")}"
        end
    end

    def won?
        if @board.flatten.select {|tile| tile.revealed?}.count == (@size**2 - 10)
            puts "You won!" 
            return true
        end
        false
    end

    def lose?
        if @lose
            puts "You hit the bomb!"
            return true
        end
        false
    end
end