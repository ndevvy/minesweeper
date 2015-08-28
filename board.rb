require_relative 'tile.rb'

class Board
  SIZE = 9
  MINE_PERCENTAGE = 20
  OFFSETS = [[-1,-1], [-1,0], [-1,1], [0,1], [1,1], [1,0], [1,-1], [0,-1]]

  attr_accessor :grid

  def initialize(grid=Array.new(SIZE) {Array.new(SIZE)})
    @grid = grid
  end

  def prepare_board
    populate_mines
    compute_neighbors
  end

  def out_of_bounds?(pos)
    drow, dcol = pos
    [drow, dcol].any? { |el| el < 0  || (el > SIZE - 1)}
  end

  def assign_bomb_counts
    all_indices = get_indices

    all_indices.each do |pos|
      compute_count(pos)
    end

    return true
  end

  def compute_count(pos)
    row, col = pos
    neighbors = grab_neighbors(pos)
    neighbors.each do |neighbor|
      row2, col2 = neighbor
      if grid[row2][col2].bomb
         grid[row][col].adj_bombs += 1
      end
    end
  end

  def get_indices
    all_indices = []
    (0...SIZE).each do |row|
      (0...SIZE).each do |col|
        all_indices << [row,col]
      end
     end
   all_indices
  end

  def grab_neighbors(pos)
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

  def populate_mines
    vals = [:bomb]
    grid.each_index do |row|
      grid[row].each_index do |column|
        grid[row][column] = make_random_tile([row, column])
      end
    end
    return true
  end

  def tile_roll
    roll = rand(100)
    roll <= MINE_PERCENTAGE
  end

  def make_random_tile(pos)
    bomb_status = tile_roll
    Tile.new(pos, bomb_status)
  end

  def render
    grid.each do |row|
    row_string = ""
      row.each do |tile|
        row_string += tile.to_s_master + " "
      end
      puts row_string
    end
    return true
  end

end
