require 'yaml'
require_relative 'player'
require_relative 'tile'
require_relative 'board'

# todo: add setup phase, high scores, timer, privatize methods
class Game

  attr_accessor :board, :name, :player

  def initialize(name="Player1")
    @name = name
    @board = Board.new
    @board.prepare_board
    @player = Player.new(@board)
  end

  def play
    until game_over? || board.savegame == true
      board.parse_input(player.move)
    end

    if board.savegame == true
      board.savegame = false
      puts "Name your saved game:"
      filename = gets.chomp
      File.write(filename, YAML.dump(self))
      play
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
