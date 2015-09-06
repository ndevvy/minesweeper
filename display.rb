require "colorize"
require_relative "cursorable"
require_relative 'minesweeper.rb'

class Display
  COLORS = {
    0 => :light_black,
    1 => :green,
    2 => :cyan,
    3 => :light_blue,
    4 => :blue,
    5 => :light_magenta,
    6 => :magenta,
    7 => :light_black,
    8 => :black
  }

  GLOBAL_BACKGROUND = :light_white

  include Cursorable

  attr_accessor :board

  def initialize(board)
    @board = board
    @cursor_pos = [0, 0]
  end

  def build_grid
    @board.grid.each_index do |i|
      rowdisplay = ""
      @board.grid[i].each_index do |j|
        output = board.grid[i][j].tilerender
        color_options = colors_for(i,j)
        rowdisplay << output.colorize(color_options) + " ".colorize(background: GLOBAL_BACKGROUND) unless output.nil?
      end
      puts rowdisplay
    end
  end


  def colors_for(i, j)

    if [i, j] == @cursor_pos
      bg = :light_red
    else
      bg = GLOBAL_BACKGROUND
    end

    if (@board.grid[i][j].hidden == false)
        color = COLORS[@board.grid[i][j].adj_bombs]
        if @board.grid[i][j].bomb == true
          color = :light_red
        end
    elsif @board.grid[i][j].flagged?
      color = :light_red
    else
      color = :white
    end
    { background: bg, color: color }
  end

  def render(last=false)
    system("clear")
    if last == false
      puts "keys or wasd to move cursor - spacebar to reveal\n  f to flag - 1 to save game"
    end
    build_grid
  end

end
