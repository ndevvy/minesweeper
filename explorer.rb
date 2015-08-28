class Explorer
  OFFSETS = [[-1,-1], [-1,0], [-1,1], [0,1], [1,1], [1,0], [1,-1], [0,-1]]

  attr_reader :board, :board_length

  def initialize(board)
    @board = board
    @board_length = board.grid.length
  end

  def neighbors(pos)
    board_length = board.grid.length
    row, col = pos
    neighbors = []
    OFFSETS.each do |pos|
      drow, dcol = [pos[0]+row, pos[1]+col]
      unless out_of_bounds?([drow,dcol])
        neighbors << [drow, dcol]
      end
    end
    neighbors
  end

  def out_of_bounds?(pos)
    drow, dcol = pos
    [drow, dcol].any? { |el| el < 0  || (el > board_length - 1)}
  end

  end

  def evaluate_neighbors(pos)

  end

end
