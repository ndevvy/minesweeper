class Tile

  attr_accessor :state, :flag
  attr_reader :pos, :val

  def initialize(pos, state=:hidden, val)
    @pos, @state, @val = pos, state, val
    @flag = false
  end

  def reveal
    state = :reveal
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

end
