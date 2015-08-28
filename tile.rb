class Tile

  attr_accessor :state, :flag, :hidden, :number, :adj_bombs
  attr_reader :pos, :bomb

  def initialize(pos, bomb=false)
    @pos, @bomb = pos, bomb
    @hidden = true
    @flag = false
    @adj_bombs = 0
  end

  def get_number
    # board needs to give number info to tiles
  end

  def reveal
    hidden = false
  end

  def flagged?
    flag == true
  end

  def flag
    flag = true
  end

  def unflag
    flag = false
  end

  def to_s_god
    if bomb
      "B"
    else
      adj_bombs.to_s
    end
    # if bomb
    #   return 'b'
    # else
    #   return '_'
    # end
  end

  def to_s
    # if flag == true
    #   "F"
    # els
    if hidden
      "-"
    else
      adj_bombs.to_s
    end
  end

end
