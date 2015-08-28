require_relative 'tile.rb'
require_relative 'explorer.rb'

class Board
  SIZE = 9
  MINE_PERCENTAGE = 20

  attr_accessor :grid

  def initialize(grid=Array.new(SIZE) {Array.new(SIZE)})
    @grid = grid
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
