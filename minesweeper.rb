require 'colorize'
require 'yaml'
require_relative 'player'

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

  def to_s_god
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

class Board

  SIZE = 10
  MINE_PERCENTAGE = 10
  OFFSETS = [[-1,-1], [-1,0], [-1,1], [0,1], [1,1], [1,0], [1,-1], [0,-1]]

  attr_accessor :grid
  attr_reader :all_indices

  def initialize(grid=Array.new(SIZE) {Array.new(SIZE)})
    @grid = grid
    @lost = false
    @won = false
  end

  def parse_input(input)

    if input == nil
      return
    end

    if input.include?(:flag)
      flag_pos(input[1])
    else
      eval_move(input)
    end

  end

   def flag_pos(pos)
     x, y = pos
     tile = grid[x][y]

     if tile.hidden == false
       return
     end

     if tile.flagged?
       tile.flag = false
       return
     else
      tile.flag = true
      return
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

  def in_bounds?(pos)
    pos.all? { |x| x.between?(0, SIZE-1) }
  end

end

class Game

  attr_accessor :board, :name, :player

  def initialize(name="Player1")
    @name = name
    @board = Board.new
    @board.prepare_board
    @player = Player.new(@board)
  end

  def play

    until game_over?
      board.parse_input(player.move)
    end

    if board.lost?
      board.all_indices.each do |idx|
        x, y = idx
        board.grid[x][y].hidden = false
      end
        @player.display.render(true)
        puts "BOOM. You lose!"
    else
      puts "You win!"
    end

  end


  def play_turn
    puts "#{name}, please make a move"
    puts "Enter 'flag' if you would like to flag a position"
    puts "Enter 'save' to save"
    input = gets.chomp
    if input.downcase == "save"
      puts "Name your saved game:"
      filename = gets.chomp
      File.write(filename, YAML.dump(self))
    else
      board.parse_input(input)
    end
  end

  def game_over?
    board.won? || board.lost?
  end

end

if __FILE__ == $PROGRAM_NAME
  case ARGV.count
  when 0
    puts 'Enter your name'
    input = gets.chomp
    Game.new(input).play
  when 1
    YAML.load_file(ARGV.shift).play
  end
end
