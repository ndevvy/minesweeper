require_relative 'board.rb'

class Game
  attr_accessor :board

  def initialize(name="Player1")
    @name = name
    @board = Board.new
  end

  def play
    board.prepare_board

    until game_over?

    end
  end

  def game_over?
    board.won? || board.lost?
  end
end
