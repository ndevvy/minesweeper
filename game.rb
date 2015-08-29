require_relative 'board.rb'

class Game
  attr_accessor :board, :name

  def initialize(name="Player1")
    @name = name
    @board = Board.new
  end

  def play
    board.prepare_board
    until game_over?
      play_turn
    end
    puts "You lose! Sorry I'm not sorry." if board.lost?
    puts "You win!"
  end

  def play_turn
    board.render
    puts "#{name}, please make a move"
    puts "Enter 'flag' if you would like to flag a position"
    puts "Enter 'save' to save"
    input = gets.chomp
    if input.downcase == "save"
      puts "Name your saved game:"
      filename = gets.chomp + ".yml"
      File.write(filename, YAML.dump(self))
      puts "Game saved to #{filename}"
    else
      board.parse_input(input)
    end
  end

  def game_over?
    board.won? || board.lost?
  end
end

if __FILE__ == $PROGRAM_NAME
  puts 'Enter your name, or enter "L" to load: '
  input = gets.chomp
  if input.downcase == "l"
    puts "Enter the name of your saved game: "
    input = gets.chomp + ".yml"
    YAML.load_file(input).play
  else
    game = Game.new(input)
    puts "Loading saved game: #{input}"
    game.play
  end
end
