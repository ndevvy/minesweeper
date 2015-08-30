require "colorize"
require_relative "cursorable"
require_relative 'minesweeper.rb'

class Display
  COLORS = {
    0 => :white,
    1 => :light_green,
    2 => :green,
    3 => :light_blue,
    4 => :blue,
    5 => :light_magenta,
    6 => :magenta,
    7 => :light_red,
    8 => :red
  }

  GLOBAL_BACKGROUND = :grey
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

    if (@board.grid[i][j].hidden == false) #&& (@board.grid[i][j].flag == false)
        color = COLORS[@board.grid[i][j].adj_bombs]
        if @board.grid[i][j].bomb == true
          color = :light_red
        end
    elsif @board.grid[i][j].flagged?
      color = :red
    else
      color = :light_white
    end
    { background: bg, color: color }
  end

  def render(last=false)
    system("clear")
    if last == false
      puts "Arrow keys or WASD to move. F to flag a tile. Space or enter to reveal."
    end
    build_grid
  end

end
