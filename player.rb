class Player
    def ininialize
    end

    def get_pos
        prompt
        parse_pos(gets.chomp)
    end

    def prompt
        puts "Select tile to reveal or flag. (r 3,4/ f 2,2)"
    end

    def parse_pos(str)
        [str[0].downcase, Integer(str[2]), Integer(str[4])]
    end
end