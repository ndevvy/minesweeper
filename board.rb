require_relative 'tile.rb'
require 'byebug'
require 'yaml'

class Board
  SIZE = 10
  MINE_PERCENTAGE = 9
  OFFSETS = [[-1,-1], [-1,0], [-1,1], [0,1], [1,1], [1,0], [1,-1], [0,-1]]

  attr_accessor :grid
  attr_reader :all_indices

  def initialize(grid=Array.new(SIZE) {Array.new(SIZE)})
    @grid = grid
    @lost = false
    @won = false
  end

  def parse_input(input)
    if input[0].downcase == "f"
      get_flag_pos
    else
      row, col = [input[0].to_i,input[-1].to_i]
      eval_move([row,col])
    end
  end

  def get_flag_pos
    while true
      puts "Enter position to toggle FLAG: "
      input = gets.chomp
      row, col = [input[0].to_i,input[-1].to_i]
      tile = grid[row][col]
      if tile.hidden == false
        puts "No flagging shown tiles, please try again."
      elsif tile.flagged?
         tile.flag = false
         return
      else
          tile.flag = true
          return
      end
   end
  end

  def prepare_board
    populate_mines
    assign_bomb_counts
    get_indices
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

  def reveal_tiles(pos)
    x, y = pos
    # debugger
    if grid[x][y].flagged?
      return
    end
    grid[x][y].hidden = false
    return if grid[x][y].adj_bombs > 0
    neighbors = grab_neighbors([x,y])
    neighbors.each do |neighbor|
      x, y = neighbor
      unless grid[x][y].hidden == false || grid[x][y].bomb
        reveal_tiles(neighbor)
      end
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
    @all_indices = []
    (0...SIZE).each do |row|
      (0...SIZE).each do |col|
        all_indices << [row,col]
      end
     end
   @all_indices
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

  def make_random_tile(pos)
    bomb_status = tile_roll
    Tile.new(pos, bomb_status)
  end

  def tile_roll
    roll = rand(100)
    roll <= MINE_PERCENTAGE
  end

  def render
    grid.each do |row|
    row_string = ""
      row.each do |tile|
        row_string += tile.to_s + " "
      end
      puts row_string
    end
    return true
  end

  def render_god
    grid.each do |row|
    row_string = ""
      row.each do |tile|
        row_string += tile.to_s_god + " "
      end
      puts row_string
    end
    return true
  end

end
