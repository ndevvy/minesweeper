class Board

  SIZE = 24
  MINE_PERCENTAGE = 10
  OFFSETS = [[-1,-1], [-1,0], [-1,1], [0,1], [1,1], [1,0], [1,-1], [0,-1]]

  attr_accessor :grid, :savegame
  attr_reader :all_indices

  def initialize(grid=Array.new(SIZE) {Array.new(SIZE)})
    @grid = grid
    @lost = false
    @won = false
  end

  def prepare_board
    populate_mines
    assign_bomb_counts
    get_indices
  end

  def parse_input(input)
    return if input == nil
    if input.include?(:flag)
      flag_pos(input[1])
    elsif input.include?(:savegame)
      @savegame = true
    else
      eval_move(input)
    end
  end

   def flag_pos(pos)
     x, y = pos
     tile = grid[x][y]

     return if tile.hidden == false

     tile.flagged? ? tile.flag = false : tile.flag = true
  end

  def lost?
    @lost
  end

  def won?
    all_indices.each do |tile|
      x, y = tile
      if grid[x][y].hidden == true && grid[x][y].bomb == false
        return false
      end
    end
    return true
  end

  def out_of_bounds?(pos)
    drow, dcol = pos
    [drow, dcol].any? { |el| el < 0  || (el > SIZE - 1)}
  end


  def eval_move(pos)
    x, y = pos
    if grid[x][y].bomb
      @lost = true
    else
      self.reveal_tiles(pos)
    end
  end

  def in_bounds?(pos)
    pos.all? { |x| x.between?(0, SIZE-1) }
  end

  def reveal_tiles(pos)
    x, y = pos
    return if grid[x][y].flagged?
    grid[x][y].hidden = false
    return if grid[x][y].adj_bombs > 0
    neighbors = find_neighbors([x,y])
    neighbors.each do |neighbor_pos|
      x, y = neighbor_pos
      reveal_tiles(neighbor_pos) unless grid[x][y].hidden == false || grid[x][y].bomb
    end
  end

  def grab_hidden_tiles(positions)
    hidden_neighbors = []
    positions.each do |pos|
      row, col = pos
      hidden_neighbors << grid[row][col] if grid[row][col].hidden
    end
    hidden_neighbors
  end

  def assign_bomb_counts
    all_indices = get_indices

    all_indices.each do |pos|
      count_adjacent_bombs(pos)
    end

    return true
  end

  def count_adjacent_bombs(pos)
    row, col = pos
    neighbors = find_neighbors(pos)
    neighbors.each do |neighbor|
      row2, col2 = neighbor
      if grid[row2][col2].bomb
         grid[row][col].adj_bombs += 1
      end
    end
  end

  def get_indices
    @all_indices = []
    (0...SIZE).each do |row|
      (0...SIZE).each do |col|
        all_indices << [row,col]
      end
     end
   @all_indices
  end

  def find_neighbors(pos)
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



end
