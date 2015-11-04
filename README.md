# Ruby Minesweeper
Command-line Minesweeper with cursor input, [colorized](https://github.com/fazibear/colorize) Unicode display, and the ability to save and load games.

## To Play
Download the .zip, extract, and run `ruby minesweeper.rb` from the root directory.  
To load a saved game, run `ruby minesweeper.rb [your saved game name]`

## Code Highlights
Each `Tile` object holds a count of its adjacent bombs (calculated when the grid is set up).
````ruby
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
````

I used a recursive method to 'sweep' the board, stopping once we find a tile with one or more adjacent bombs.
```` ruby
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
````
