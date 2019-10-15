class Tile

    attr_reader :neighbor_bomb_count

    def initialize(bombed = false, neighbor_bomb_count)
        @bombed = bombed
        @flagged = false
        @revealed = false
        @neighbor_bomb_count = neighbor_bomb_count
    end

    def bombed?
        @bombed
    end

    def reveal
        flagged? ? (return false) : @revealed = true
        true
    end

    def revealed?
        @revealed
    end

    def flag
        flagged? ? @flagged = false : @flagged = true
    end

    def flagged?
        @flagged
    end

    def to_s
        revealed? ? (@neighbor_bomb_count == 0 ? "_" : @neighbor_bomb_count.to_s) : (flagged? ? "F" : "*")
    end

end