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
    puts "You lose! Sorry I'm not sorry." if board.lost
  end

  def play_turn
    board.render
    puts "#{name}, please make a move"
    puts "Enter 'flag' if you would like to flag a position"
  
    input = gets.chomp
    board.parse_input(input)
  end

  def game_over?
    board.won? || board.lost?
  end
end
