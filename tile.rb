class Tile

  attr_accessor :state, :flag, :hidden, :number, :adj_bombs
  attr_reader :pos, :bomb

  def initialize(pos, bomb=false)
    @pos, @bomb = pos, bomb
    @hidden = true
    @flag = false
    @adj_bombs = 0
  end

  def reveal
    hidden = false
  end

  def bomb?
    @bomb == true
  end

  def flagged?
    @flag == true
  end

  def flag
    flag = true
  end

  def unflag
    flag = false
  end

  def to_s_god # god mode for debugging
    if bomb
      "B"
    else
      adj_bombs.to_s
    end
  end

  def tilerender
    if flagged?
      return "\u2691".encode('utf-8')
    elsif hidden
      return "\u25A0".encode('utf-8')
    elsif bomb? == true
      return "\u2688".encode('utf-8')
    else
      return self.adj_bombs.to_s
    end
  end

end
