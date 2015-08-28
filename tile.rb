class Tile

  attr_accessor :state, :flag, :hidden, :number
  attr_reader :pos, :bomb

  def initialize(pos, bomb=false)
    @pos, @state, @bomb = pos, state, bomb
    @hidden = true
    @flag = false
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

  def to_s_master
    if bomb
      return 'b'
    else
      return '_'
    end
  end

  def to_s
    
  end

end
